//
//  CLJPersistentVector.m
//  PersistentStructure
//
//  Created by Robert Widmann on 12/30/13.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJPersistentVector.h"
#import "CLJPersistentVectorIterator.h"
#import "CLJISeq.h"
#import "CLJITransientVector.h"
#import "CLJITransientCollection.h"
#import "CLJITransientMap.h"
#import "CLJITransientAssociative.h"
#import "CLJNode.h"
#import "CLJTransientVector.h"
#import "CLJUtils.h"
#import "CLJChunkedSeq.h"

@implementation CLJPersistentVector {
	NSInteger _count;
	NSInteger _shift;
	CLJNode *_root;
	CLJArray _tail;
	id<CLJIPersistentMap> _meta;
}

static NSThread *const NOEDIT = nil;
static CLJNode *CLJEmptyNode = nil;
static CLJPersistentVector *EMPTY = nil;

+ (void)load {
	if (self.class != CLJPersistentVector.class) {
		return;
	}
	CLJEmptyNode = [[CLJNode alloc] initWithThread:NOEDIT];
	EMPTY = [[CLJPersistentVector alloc] initWithCount:0 shift:5 root:(id<CLJINode>)CLJEmptyNode tail:CLJArrayCreate(0)];
}

+ (CLJPersistentVector *)createWithSeq:(id<CLJISeq>)items {
	id<CLJITransientVector> ret = (id<CLJITransientVector>)EMPTY.asTransient;
	for (; items != nil; items = items.next) {
		ret = (id<CLJITransientVector>)[ret conj:items.first];
	}
	return (CLJPersistentVector *)ret.persistent;
}

+ (CLJPersistentVector *)createWithList:(id<CLJIList>)list {
	CLJTransientVector *ret = (CLJTransientVector *)EMPTY.asTransient;
	for (id item in list) {
		ret = (CLJTransientVector *)[ret conj:item];
	}
	return (CLJPersistentVector *)ret.persistent;
}

+ (CLJPersistentVector *)createWithItems:(CLJArray)items {
	CLJTransientVector *ret = (CLJTransientVector *)EMPTY.asTransient;
	for (NSInteger i = 0; i < items.length; i++) {
		ret = (CLJTransientVector *)[ret conj:items.array[i]];
	}
	return (CLJPersistentVector *)ret.persistent;
}

+ (CLJPersistentVector *)empty {
	return EMPTY;
}

+ (CLJNode *)emptyNode {
	return CLJEmptyNode;
}

- (id)initWithCount:(NSInteger)cnt shift:(NSInteger)shift root:(id<CLJINode>)root tail:(CLJArray)tail {
	self = [super init];
	
	_meta = nil;
	_count = cnt;
	_shift = shift;
	_root = root;
	_tail = tail;
	
	return self;
}

- (id)initWithMeta:(id<CLJIPersistentMap>)meta count:(NSInteger)cnt shift:(NSInteger)shift node:(CLJNode *)root tail:(CLJArray)tail {
	self = [super init];
	
	_meta = meta;
	_count = cnt;
	_shift = shift;
	_root = root;
	_tail = tail;
	
	return self;
}

- (id<CLJITransientCollection>)asTransient {
	return [[CLJTransientVector alloc] initWithPersistentVector:self];
}

- (NSInteger)shift {
	return _shift;
}

- (CLJNode *)root {
	return _root;
}

- (CLJArray)tail {
	return _tail;
}

- (NSInteger)tailoff {
	if (_count < 32) {
		return 0;
	}
	return ((_count - 1) >> 5) << 5;
}

- (CLJArray)arrayFor:(NSInteger)i {
	if (i >= 0 && i < _count) {
		if (i >= self.tailoff) {
			return _tail;
		}
		CLJNode *node = _root;
		for (NSInteger level = _shift; level > 0; level -= 5) {
			node = (CLJNode *) node.array.array[(i >> level) & 0x01f];
		}
		return node.array;
	}
	[NSException raise:NSRangeException format:@"Range or index out of bounds"];
	return (CLJArray){};
}

- (id)nth:(NSInteger)i {
	CLJArray node = [self arrayFor:i];
	return node.array[i & 0x01f];
}

- (id)nth:(NSInteger)i default:(id)notFound {
	if (i >= 0 && i < _count) {
		return [self nth:i];
	}
	return notFound;
}

- (id<CLJIPersistentVector>)assocN:(NSInteger)i value:(id)val {
	if (i >= 0 && i < _count) {
		if (i >= self.tailoff) {
			CLJArray newTail = CLJArrayCreate(_tail.length);
			CLJArrayCopy(_tail, 0, newTail, 0, _tail.length);
			newTail.array[i & 0x01f] = val;
			return [[CLJPersistentVector alloc] initWithMeta:self.meta count:_count shift:_shift node:_root tail:newTail];
		}
		return [[CLJPersistentVector alloc] initWithMeta:self.meta count:_count shift:_shift node:[CLJPersistentVector doAssocAtLevel:_shift node:_root index:i value:val] tail:_tail];
	}
	if (i == _count) {
		return [self cons:val];
	}
	[NSException raise:NSRangeException format:@"Range or index out of bounds"];
	return nil;
}

+ (CLJNode *)doAssocAtLevel:(NSInteger)level node:(CLJNode *)node index:(NSInteger)i value:(id)val {
	CLJNode *ret = [[CLJNode alloc] initWithThread:node.edit array:CLJArrayCreateCopy(node.array)];
	if (level == 0) {
		ret.array.array[i & 0x01f] = val;
	} else {
		NSInteger subidx = (i >> level) & 0x01f;
		ret.array.array[subidx] = [CLJPersistentVector doAssocAtLevel:level - 5 node:(CLJNode *)node.array.array[subidx] index:i value:val];
	}
	return ret;
}

- (NSUInteger)count {
	return _count;
}

- (id<CLJIObj>)withMeta:(id<CLJIPersistentMap>)meta {
	return [[CLJPersistentVector alloc] initWithMeta:meta count:_count shift:_shift node:_root tail:_tail];
}

- (id<CLJIPersistentMap>)meta {
	return _meta;
}


- (id<CLJIPersistentVector>)cons:(id)val {
	//room in tail?
	if (_count - self.tailoff < 32) {
		CLJArray newTail = CLJArrayCreate(_tail.length + 1);
		CLJArrayCopy(_tail, 0, newTail, 0, _tail.length);
		newTail.array[_tail.length] = val;
		return [[CLJPersistentVector alloc] initWithMeta:self.meta count:_count + 1 shift:_shift node:_root tail:newTail];
	}
	//full tail, push into tree
	CLJNode *newroot;
	CLJNode *tailnode = [[CLJNode alloc] initWithThread:_root.edit array:_tail];
	NSInteger newshift = _shift;
	//overflow root?
	if ((_count >> 5) > (1 << _shift)) {
		newroot = [[CLJNode alloc] initWithThread:_root.edit];
		newroot.array.array[0] = _root;
		newroot.array.array[1] = [CLJPersistentVector newPath:_root.edit level:_shift node:tailnode];
		newshift += 5;
	} else {
		newroot = [self pushTailAtLevel:_shift parent:_root tail:tailnode];
	}
	__strong id arr[] = { val };
	return [[CLJPersistentVector alloc] initWithMeta:self.meta count:_count + 1 shift:newshift node:newroot tail:(CLJArray){
		.array = arr,
		.length = 1,
	}];
}

- (CLJNode *)pushTailAtLevel:(NSInteger)level parent:(CLJNode *)parent tail:(CLJNode *)tailnode {
	//if parent is leaf, insert node,
	// else does it map to an existing child? -> nodeToInsert = pushNode one more level
	// else alloc new path
	//return  nodeToInsert placed in copy of parent
	NSInteger subidx = ((_count - 1) >> level) & 0x01f;
	CLJNode *ret = [[CLJNode alloc] initWithThread:parent.edit array:CLJArrayCreateCopy(parent.array)];
	CLJNode *nodeToInsert;
	if (level == 5) {
		nodeToInsert = tailnode;
	} else {
		CLJNode * child = (CLJNode *) parent.array.array[subidx];
		nodeToInsert = (child != nil) ? [self pushTailAtLevel:level - 5 parent:child tail:tailnode] : [CLJPersistentVector newPath:_root.edit level:level - 5 node:tailnode];
	}
	ret.array.array[subidx] = nodeToInsert;
	return ret;
}

+ (CLJNode *)newPath:(NSThread *)edit level:(NSInteger)level node:(CLJNode *)node {
	if (level == 0) {
		return node;
	}
	CLJNode *ret = [[CLJNode alloc] initWithThread:edit];
	ret.array.array[0] = [CLJPersistentVector newPath:edit level:level - 5 node:node];
	return ret;
}

- (id<CLJIChunkedSeq>)chunkedSeq {
	if (self.count == 0) {
		return nil;
	}
	return [[CLJChunkedSeq alloc] initWithVec:self index:0 offset:0];
}

- (id<CLJISeq>)seq {
	return self.chunkedSeq;
}

- (NSEnumerator *)objectEnumerator {
	return [[CLJPersistentVectorIterator alloc] initWithVector:self start:0];
}

- (id)kvreduce:(CLJIKeyValueReduceBlock)f init:(id)init {
	NSInteger step = 0;
	for (NSInteger i=0;i<_count;i+=step){
		CLJArray array = [self arrayFor:i];
		for (NSInteger j =0;j<array.length;++j){
			init = f(init,@(j+i),array.array[j]);
			if ([CLJUtils isReduced:init]) {
				return ((id<CLJIDeref>)init).deref;
			}
		}
		step = array.length;
	}
	return init;
}

- (id<CLJIPersistentCollection>)empty {
	return (id<CLJIPersistentCollection>)[EMPTY withMeta:self.meta];
}

- (id<CLJIPersistentStack>)pop {
	if (_count == 0) {
		[NSException raise:NSInternalInconsistencyException format:@"Can't pop from an empty vector"];
	}
	if (_count == 1) {
		return (id<CLJIPersistentStack>)[EMPTY withMeta:self.meta];
	}
	if (_count-self.tailoff > 1) {
		CLJArray newTail = CLJArrayCreate(_tail.length - 1);
		CLJArrayCopy(_tail, 0, newTail, 0, newTail.length);
		return [[CLJPersistentVector alloc] initWithMeta:self.meta count:_count - 1 shift:_shift node:_root tail:newTail];
	}
	CLJArray newtail = [self arrayFor:_count - 2];
	
	CLJNode *newroot = [self popTailAtLevel:_shift node:_root];
	NSInteger newshift = _shift;
	if (newroot == nil) {
		newroot = CLJEmptyNode;
	}
	if (_shift > 5 && newroot.array.array[1] == nil) {
		newroot = (CLJNode *) newroot.array.array[0];
		newshift -= 5;
	}
	return [[CLJPersistentVector alloc] initWithMeta:self.meta count:_count - 1  shift:newshift node:newroot tail:newtail];
}

- (CLJNode *)popTailAtLevel:(NSInteger)level node:(CLJNode *)node {
	NSInteger subidx = ((_count-2) >> level) & 0x01f;
	if (level > 5) {
		CLJNode * newchild = [self popTailAtLevel:level - 5 node:node.array.array[subidx]];
		if (newchild == nil && subidx == 0) {
			return nil;
		} else {
			CLJNode * ret = [[CLJNode alloc] initWithThread:_root.edit array:CLJArrayCreateCopy(node.array)];
			ret.array.array[subidx] = newchild;
			return ret;
		}
	} else if (subidx == 0) {
		return nil;
	} else {
		CLJNode * ret = [[CLJNode alloc] initWithThread:_root.edit array:CLJArrayCreateCopy(node.array)];
		ret.array.array[subidx] = nil;
		return ret;
	}
}

@end
