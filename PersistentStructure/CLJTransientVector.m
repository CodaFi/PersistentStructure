//
//  CLJTransientVector.m
//  PersistentStructure
//
//  Created by Robert Widmann on 3/26/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJTransientVector.h"
#import "CLJPersistentVector.h"
#import "CLJNode.h"
#import "CLJUtils.h"

@implementation CLJTransientVector {
	NSInteger _count;
	NSInteger _shift;
	CLJNode *_root;
	CLJArray _tail;
}

- (id)initWithCount:(NSInteger)cnt shift:(NSInteger)shift node:(CLJNode *)root tail:(CLJArray)tail {
	self = [super init];
	
	_count = cnt;
	_shift = shift;
	_root = root;
	_tail = tail;
	
	return self;
}

- (id)initWithPersistentVector:(CLJPersistentVector *)v {
	return [self initWithCount:v.count shift:v.shift node:[self editableRoot:v.root] tail:[self editableTail:v.tail]];
}

- (NSUInteger)count {
	[self ensureEditable];
	return _count;
}

- (CLJNode *)ensureEditableNode:(CLJNode *)node {
	if (node.edit == _root.edit) {
		return node;
	}
	return [[CLJNode alloc] initWithThread:_root.edit array:_root.array];
}

- (void)ensureEditable {
	NSThread *owner = _root.edit;
	if (owner == NSThread.currentThread) {
		return;
	}
	if (owner != nil) {
		[NSException raise:NSInternalInconsistencyException format:@"Transient used by non-owner thread"];
	}
	[NSException raise:NSInternalInconsistencyException format:@"Transient used after request to be made persistent"];
}

- (CLJNode *)editableRoot:(CLJNode *)node {
	return [[CLJNode alloc] initWithThread:NSThread.currentThread array:node.array];
}

- (id<CLJIPersistentCollection>)persistent {
	[self ensureEditable];
	if (_root.edit != nil && _root.edit != NSThread.currentThread) {
		[NSException raise:NSInternalInconsistencyException format:@"Mutation release by non-owner thread"];
	}
//	_root.edit = nil;
	CLJArray trimmedTail = CLJArrayCreate(_count-self.tailoff);
	CLJArrayCopy(_tail,0,trimmedTail,0,trimmedTail.length);
	return [[CLJPersistentVector alloc] initWithCount:_count shift:_shift root:(id<CLJINode>)_root tail:trimmedTail];
}

- (CLJArray)editableTail:(CLJArray)tl {
	CLJArray ret = CLJArrayCreate(32);
	CLJArrayCopy(tl,0,ret,0,tl.length);
	return ret;
}

- (id<CLJITransientCollection>)conj:(id)val {
	[self ensureEditable];
	NSInteger i = _count;
	//room in tail?
	if (i - self.tailoff < 32) {
		_tail.array[i & 0x01f] = val;
		_count++;
		return self;
	}
	//full tail, push into tree
	CLJNode *newroot;
	CLJNode *tailnode = [[CLJNode alloc] initWithThread:_root.edit array:_tail];
	_tail = CLJArrayCreate(32);
	_tail.array[0] = val;
	NSInteger newshift = _shift;
	//overflow root?
	if ((_count >> 5) > (1 << _shift)) {
		newroot = [[CLJNode alloc] initWithThread:_root.edit];
		newroot.array.array[0] = _root;
		newroot.array.array[1] = [CLJTransientVector newPath:_root.edit level:_shift node:tailnode];
		newshift += 5;
	}
	else
		newroot = [self pushTailAtLevel:_shift parent:_root tail:tailnode];
	_root = newroot;
	_shift = newshift;
	_count++;
	return self;
}

- (CLJNode *)pushTailAtLevel:(NSInteger)level parent:(CLJNode *)parent tail:(CLJNode *)tailnode {
	//if parent is leaf, insert node,
	// else does it map to an existing child? -> nodeToInsert = pushNode one more level
	// else alloc new path
	//return  nodeToInsert placed in parent
	parent = [self ensureEditableNode:parent];
	NSInteger subidx = ((_count - 1) >> level) & 0x01f;
	CLJNode *ret = parent;
	CLJNode *nodeToInsert;
	if (level == 5) {
		nodeToInsert = tailnode;
	}
	else
	{
		CLJNode *child = (CLJNode *) parent.array.array[subidx];
		nodeToInsert = (child != nil) ? [self pushTailAtLevel:level - 5 parent:child tail:tailnode] : [CLJTransientVector newPath:_root.edit level:level - 5 node:tailnode];
	}
	ret.array.array[subidx] = nodeToInsert;
	return ret;
}

+ (CLJNode *)newPath:(NSThread *)edit level:(NSInteger)level node:(CLJNode *)node {
	if (level == 0)
		return node;
	CLJNode *ret = [[CLJNode alloc] initWithThread:edit];
	ret.array.array[0] = [CLJTransientVector newPath:edit level:level - 5 node:node];
	return ret;
}

- (NSInteger)tailoff {
	if (_count < 32) {
		return 0;
	}
	return ((_count-1) >> 5) << 5;
}

- (CLJArray)arrayFor:(NSInteger)i {
	if (i >= 0 && i < _count) {
		if (i >= self.tailoff)
			return _tail;
		CLJNode *node = _root;
		for (NSInteger level = _shift; level > 0; level -= 5)
			node = (CLJNode *) node.array.array[ (i >> level) & 0x01f];
		return node.array;
	}
	[NSException raise:NSRangeException format:@"Range or index out of bounds"];
	return (CLJArray){};
}

- (CLJArray)editableArrayFor:(NSInteger)i {
	if (i >= 0 && i < _count) {
		if (i >= self.tailoff)
			return _tail;
		CLJNode *node = _root;
		for (NSInteger level = _shift; level > 0; level -= 5)
			node = (CLJNode *) node.array.array[(i >> level) & 0x01f];
		return node.array;
	}
	[NSException raise:NSRangeException format:@"Range or index out of bounds"];
	return (CLJArray){};
}

- (id)objectForKey:(id)key {
	//note - relies on ensureEditable in 2-arg objectForKey
	return [self objectForKey:key default:nil];
}

- (id)objectForKey:(id)key default:(id)notFound {
	[self ensureEditable];
	if ([CLJUtils isInteger:key]) {
		NSInteger i = ((NSNumber *) key).intValue;
		if (i >= 0 && i < _count)
			return [self objectAtIndex:i];
	}
	return notFound;
}

- (id)objectAtIndex:(NSInteger)i {
	[self ensureEditable];
	CLJArray node = [self arrayFor:i];
	return node.array[i & 0x01f];
}

- (id)objectAtIndex:(NSInteger)i default:(id)notFound {
	if (i >= 0 && i < self.count)
		return [self objectAtIndex:i];
	return notFound;
}

- (id<CLJITransientVector>)assocN:(NSInteger)i value:(id)val {
	[self ensureEditable];
	if (i >= 0 && i < _count) {
		if (i >= self.tailoff) {
			_tail.array[i & 0x01f] = val;
			return self;
		}
		
		_root = [self doAssocAtLevel:_shift node:_root index:i value:val];
		return self;
	}
	if (i == _count) {
		return (id<CLJITransientVector>)[self conj:val];
	}
	[NSException raise:NSRangeException format:@"Range or index out of bounds"];
	return nil;
}

- (id<CLJITransientAssociative>)associateKey:(id)key value:(id)val {
	//note - relies on ensureEditable in assocN
	if ([CLJUtils isInteger:key]) {
		NSInteger i = ((NSNumber *) key).intValue;
		return [self assocN:i value:val];
	}
	[NSException raise:NSInvalidArgumentException format:@"Key must be an integer"];
	return nil;
}

- (CLJNode *)doAssocAtLevel:(NSInteger)level node:(CLJNode *)node index:(NSInteger)i value:(id)val {
	node = [self ensureEditableNode:node];
	CLJNode *ret = node;
	if (level == 0) {
		ret.array.array[i & 0x01f] = val;
	} else {
		NSInteger subidx = (i >> level) & 0x01f;
		ret.array.array[subidx] = [self doAssocAtLevel:level - 5 node:(CLJNode *)node.array.array[subidx] index:i value:val];
	}
	return ret;
}

- (id<CLJITransientVector>)pop {
	[self ensureEditable];
	if (_count == 0) {
		[NSException raise:NSInternalInconsistencyException format:@"Can't pop from an empty vector"];
	}
	if (_count == 1) {
		_count = 0;
		return self;
	}
	NSInteger i = _count - 1;
	//pop in tail?
	if ((i & 0x01f) > 0) {
		--_count;
		return self;
	}
	
	CLJArray newtail = [self editableArrayFor:_count - 2];
	
	CLJNode *newroot = [self popTailAtLevel:_shift node:_root];
	NSInteger newshift = _shift;
	if (newroot == nil) {
		newroot = [[CLJNode alloc] initWithThread:_root.edit];
	}
	if (_shift > 5 && newroot.array.array[1] == nil) {
		newroot = [self ensureEditableNode:(CLJNode *)newroot.array.array[0]];
		newshift -= 5;
	}
	_root = newroot;
	_shift = newshift;
	--_count;
	_tail = newtail;
	return self;
}

- (CLJNode *)popTailAtLevel:(NSInteger)level node:(CLJNode *)node {
	node = [self ensureEditableNode:node];
	NSInteger subidx = ((_count - 2) >> level) & 0x01f;
	if (level > 5) {
		CLJNode *newchild = [self popTailAtLevel:level - 5 node:(CLJNode *)node.array.array[subidx]];
		if (newchild == nil && subidx == 0) {
			return nil;
		} else {
			CLJNode *ret = node;
			ret.array.array[subidx] = newchild;
			return ret;
		}
	} else if (subidx == 0) {
		return nil;
	} else {
		CLJNode * ret = node;
		ret.array.array[subidx] = nil;
		return ret;
	}
}

@end
