//
//  CLJPersistentHashMap.m
//  PersistentStructure
//
//  Created by Robert Widmann on 12/30/13.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJPersistentHashMap.h"
#import "CLJInterfaces.h"
#import "CLJMapEntry.h"
#import "CLJBox.h"
#import "CLJAbstractCons.h"
#import "CLJUtils.h"
#import "CLJAbstractTransientMap.h"
#import "CLJTransientHashMap.h"
#import "CLJBitmapIndexedNode.h"
#import "CLJSeq.h"
#import "CLJSeqIterator.h"

static CLJPersistentHashMap *_CLJEmptyPersistentHashMap = nil;
static id _CLJNOT_FOUND = nil;

@implementation CLJPersistentHashMap {
	NSUInteger _count;
	id<CLJINode> _root;
	BOOL _hasNull;
	id _nullValue;
	id<CLJIPersistentMap> _meta;
}

+ (void)load {
	if (self.class != CLJPersistentHashMap.class) {
		return;
	}
	_CLJEmptyPersistentHashMap = [[CLJPersistentHashMap alloc] initWithCount:0 root:nil hasNull:false nullValue:nil];
	_CLJNOT_FOUND = NSNull.null;
}

+ (id<CLJIPersistentMap>)create:(id<CLJIMap>)other {
	id<CLJITransientMap> ret = (id<CLJITransientMap>)_CLJEmptyPersistentHashMap.asTransient;
	for (id o in other.entrySet) {
		id<CLJIMapEntry> e = (id<CLJIMapEntry>) o;
		ret = [ret associateKey:e.getKey value:e.getValue];
	}
	return ret.persistent;
}

+ (CLJPersistentHashMap *)createList:(id)init, ... NS_REQUIRES_NIL_TERMINATION {
	id<CLJITransientMap> ret = (id<CLJITransientMap>)_CLJEmptyPersistentHashMap.asTransient;
	va_list args;
	va_start(args, init);
	for (id curVal = init; curVal != nil; curVal = va_arg(args, id)) {
		id nxtVal = va_arg(args, id);
		ret = [ret associateKey:curVal value:nxtVal];
	}
	va_end(args);
	return (CLJPersistentHashMap *)ret.persistent;
}

+ (CLJPersistentHashMap *)createV:(va_list)init {
	id<CLJITransientMap> ret = (id<CLJITransientMap>)_CLJEmptyPersistentHashMap.asTransient;
	for (id curVal = va_arg(init, id); curVal != nil; curVal = va_arg(init, id)) {
		id nxtVal = va_arg(init, id);
		ret = [ret associateKey:curVal value:nxtVal];
	}
	return (CLJPersistentHashMap *)ret.persistent;
}

+ (CLJPersistentHashMap *)createWithCheck:(id)init, ... NS_REQUIRES_NIL_TERMINATION {
	NSInteger i = 0;
	id<CLJITransientMap> ret = (id<CLJITransientMap>)_CLJEmptyPersistentHashMap.asTransient;
	va_list args;
	va_start(args, init);
	for (id curVal = init; curVal != nil; curVal = va_arg(args, id)) {
		id nxtVal = va_arg(args, id);
		ret = [ret associateKey:curVal value:nxtVal];
		if (ret.count != i/2 + 1) {
			NSAssert(0, @"Duplicate key: %@", curVal);
		}
		i++;
	}
	va_end(args);
	return (CLJPersistentHashMap *)ret.persistent;
}

+ (CLJPersistentHashMap *)createWithSeq:(id<CLJISeq>)items {
	id<CLJITransientMap> ret = (id<CLJITransientMap>)_CLJEmptyPersistentHashMap.asTransient;
	for (; items != nil; items = items.next.next) {
		if (items.next == nil) {
			NSAssert(0, @"No value supplied for key: %@", items.first);
		}
		ret = [ret associateKey:items.first value:[CLJUtils second:items]];
	}
	return (CLJPersistentHashMap *) ret.persistent;
}

+ (CLJPersistentHashMap *)createWithCheckSeq:(id<CLJISeq>)items {
	id<CLJITransientMap> ret = (id<CLJITransientMap>)_CLJEmptyPersistentHashMap.asTransient;
	for (NSInteger i = 0; items != nil; items = items.next.next, ++i) {
		if (items.next == nil) {
			NSAssert(0, @"No value supplied for key: %@", items.first);
		}
		ret = [ret associateKey:items.first value:[CLJUtils second:items]];
		if (ret.count != i + 1) {
			NSAssert(0, @"Duplicate key: %@", items.first);
		}
	}
	return (CLJPersistentHashMap *) ret.persistent;
}

+ (CLJPersistentHashMap *)createWithMeta:(id<CLJIPersistentMap>)meta values:(id)init, ... {
	va_list arglist;
	va_start(arglist, init);
	CLJPersistentHashMap *map = [CLJPersistentHashMap createV:arglist];
	va_end(arglist);
	return [map withMeta:meta];
}

+ (CLJPersistentHashMap *)createWithMeta:(id<CLJIPersistentMap>)meta array:(CLJArray)array {
	return [CLJPersistentHashMap createWithSeq:[CLJSeq create:array]];
}

- (id)initWithCount:(NSUInteger)count root:(id<CLJINode>)root hasNull:(BOOL)hasNull nullValue:(id)nullValue {
	self = [super init];
	_count = count;
	_root = root;
	_hasNull = hasNull;
	_nullValue = nullValue;
	_meta = nil;
	return self;
}

- (id)initWithMeta:(id<CLJIPersistentMap>)meta count:(NSUInteger)count root:(id<CLJINode>)root hasNull:(BOOL)hasNull nullValue:(id)nullValue {
	self = [super init];
	_meta = meta;
	_count = count;
	_root = root;
	_hasNull = hasNull;
	_nullValue = nullValue;
	return self;
}

+ (NSInteger)hash:(id)k {
	return [CLJUtils hasheq:k];
}

- (BOOL)containsKey:(id)key {
	if (key == nil) {
		return _hasNull;
	}
	return (_root != nil) ? [_root findWithShift:0 hash:[CLJPersistentHashMap hash:key] key:key notFound:_CLJNOT_FOUND] != _CLJNOT_FOUND : NO;
}

- (id<CLJIMapEntry>)objectForKey:(id)key {
	if (key == nil) {
		return _hasNull ? [[CLJMapEntry alloc]initWithKey:nil val:_nullValue] : nil;
	}
	return (_root != nil) ? [_root findWithShift:0 hash:[CLJPersistentHashMap hash:key] key:key] : nil;
}

- (id<CLJIPersistentMap>)associateKey:(id)key value:(id)val {
	if (key == nil) {
		if (_hasNull && val == _nullValue) {
			return nil;
		}
		return [[CLJPersistentHashMap alloc]initWithMeta:self.meta count:_hasNull ? _count : _count + 1 root:_root hasNull:YES nullValue:val];
	}
	CLJBox *addedLeaf = [CLJBox boxWithVal:nil];
	id<CLJINode> newroot = [(_root == nil ? CLJBitmapIndexedNode.empty : _root) assocWithShift:0 hash:[CLJUtils hash:key] key:key value:val addedLeaf:addedLeaf];
	if (newroot == _root) {
		return self;
	}
	return [[CLJPersistentHashMap alloc] initWithMeta:self.meta count:addedLeaf.val == nil ? _count : _count + 1 root:newroot hasNull:_hasNull nullValue:_nullValue];
}

- (id)valAt:(id)key default:(id)notFound {
	if (key == nil) {
		return _hasNull ? _nullValue : notFound;
	}
	return _root != nil ? [_root findWithShift:0 hash:[CLJPersistentHashMap hash:key] key:key notFound:notFound] : notFound;
}

- (id)valAt:(id)key {
	return [self valAt:key default:nil];
}

- (id<CLJIPersistentMap>)assocEx:(id)key value:(id)val {
	if ([self containsKey:key]) {
		@throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Key already present" userInfo:nil];
	}
	return [self associateKey:key value:val];
}

- (id<CLJIPersistentMap>)without:(id)key {
	if (key == nil) {
		return _hasNull ? [[CLJPersistentHashMap alloc] initWithMeta:self.meta count:_count - 1 root:_root hasNull:NO nullValue:nil] : self;
	}
	if (_root == nil) {
		return self;
	}
	id<CLJINode> newroot = [_root withoutWithShift:0 hash:[CLJPersistentHashMap hash:key] key:key];
	if (newroot == _root) {
		return self;
	}
	return [[CLJPersistentHashMap alloc] initWithMeta:self.meta count:_count - 1 root:newroot hasNull:_hasNull nullValue:_nullValue];
}

- (NSEnumerator *)objectEnumerator {
	return [[CLJSeqIterator alloc] initWithSeq:self.seq];
}

- (id)kvreduce:(CLJIKeyValueReduceBlock)f init:(id)init {
	init = _hasNull ? f(init, nil, _nullValue) : init;
	if ([CLJUtils isReduced:init]) {
		return ((id<CLJIDeref>)init).deref;
	}
	if (_root != nil){
		return [_root kvreduce:f init:init];
	}
	return init;
}

//public Object fold(long n, final IFn combinef, final IFn reducef,
//				   IFn fjinvoke, final IFn fjtask, final IFn fjfork, final IFn fjjoin){
//	//we are ignoring n for now
//	Callable top = new Callable(){
//		public Object call() throws Exception{
//			Object ret = combinef.invoke();
//			if (root != null)
//				ret = combinef.invoke(ret, root.fold(combinef,reducef,fjtask,fjfork,fjjoin));
//			return hasNull?
//			combinef.invoke(ret,reducef.invoke(combinef.invoke(),null,nullValue))
//			:ret;
//		}
//	};
//	return fjinvoke.invoke(top);
//}

- (NSUInteger)count {
	return _count;
}

- (id<CLJISeq>)seq {
	id<CLJISeq> s = _root != nil ? _root.nodeSeq : nil;
	return _hasNull ? [[CLJAbstractCons alloc]initWithFirst:[[CLJMapEntry alloc]initWithKey:nil val:_nullValue] rest:s]: s;
}

+ (id<CLJIPersistentCollection>)empty {
	return _CLJEmptyPersistentHashMap;
}

- (CLJPersistentHashMap *)withMeta:(id<CLJIPersistentMap>)meta {
	return [[CLJPersistentHashMap alloc]initWithMeta:_meta count:_count root:_root hasNull:_hasNull nullValue:_nullValue];
}

- (CLJTransientHashMap *)asTransient {
	return [CLJTransientHashMap create:self];
}

- (id<CLJIPersistentMap>)meta {
	return _meta;
}

- (id<CLJINode>)root {
	return _root;
}

- (BOOL)hasNull {
	return _hasNull;
}

- (id)nullValue {
	return _nullValue;
}

@end
