//
//  CLJPersistentArrayMap.m
//  PersistentStructure
//
//  Created by Robert Widmann on 3/27/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJPersistentArrayMap.h"
#import "CLJTransientArrayMap.h"
#import "CLJPersistentHashMap.h"
#import "CLJMapEntry.h"
#import "CLJSeq.h"
#import "CLJUtils.h"

static const NSInteger HASHTABLE_THRESHOLD = 16;
static CLJPersistentArrayMap *EMPTY;

@implementation CLJPersistentArrayMap {
	CLJArray _array;
	id<CLJIPersistentMap> _meta;
}

- (id)init {
	self = [super init];
	
	_array = CLJArrayCreate(0);
	_meta = nil;
	
	return self;
}

- (id)initWithMap:(id<CLJIMap>)other {
	id<CLJITransientMap> ret = (id<CLJITransientMap> )EMPTY.asTransient;
	for (id o in other.allEntries) {
		CLJMapEntry *e = (CLJMapEntry *) o;
		ret = [ret associateKey:e.key value:e.val];
	}
	return (CLJPersistentArrayMap *)ret.persistent;
}

- (id<CLJIObj>)withMeta:(id<CLJIPersistentMap>)meta {
	return [[CLJPersistentArrayMap alloc] initWithMeta:meta array:_array];
}

//PersistentArrayMap create(Object... init){
//	return new PersistentArrayMap(meta(), init);
//}

- (id)initWithArray:(CLJArray)init {
	self = [super init];
	
	_array = init;
	_meta = nil;
	
	return self;
}

- (id)initWithMeta:(id<CLJIPersistentMap>)meta array:(CLJArray)init {
	self = [super init];
	
	_meta = meta;
	_array = init;
	
	return self;
}

- (id<CLJIPersistentMap>)createHT:(CLJArray)init {
	return [CLJPersistentHashMap createWithMeta:self.meta array:init];
}

+ (CLJPersistentArrayMap *)createWithCheck:(CLJArray)init {
	for (NSUInteger i = 0;i< init.length;i += 2) {
		for (NSUInteger j = i + 2; j < init.length; j += 2) {
			if ([CLJPersistentArrayMap equalKey:init.array[i] other:init.array[j]]) {
				[NSException raise:NSInvalidArgumentException format:@"Duplicate key found at index %tu", i];
			}
		}
	}
	return [[CLJPersistentArrayMap alloc] initWithArray:init];
}

- (NSUInteger)count {
	return _array.length / 2;
}

- (BOOL)containsKey:(id)key {
	return [self indexOf:key] >= 0;
}

- (id<CLJIMapEntry>)entryForKey:(id)key {
	NSInteger i = [self indexOf:key];
	if (i >= 0) {
		return [[CLJMapEntry alloc] initWithKey:_array.array[i] val:_array.array[i + 1]];
	}
	return nil;
}

- (id<CLJIPersistentMap>)assocEx:(id)key value:(id)val {
	NSInteger i = [self indexOf:key];
	CLJArray newArray;
	if (i >= 0) {
		[NSException raise:NSInternalInconsistencyException format:@"Key %@ already present in array map %@", key, self];
	}
	else { //didn't have key, grow
		if (_array.length > HASHTABLE_THRESHOLD) {
			return [[self createHT:_array] assocEx:key value:val];
		}
		newArray = CLJArrayCreate(_array.length + 2);
		if (_array.length > 0) {
			CLJArrayCopy(_array, 0, newArray, 2, _array.length);
		}
		newArray.array[0] = key;
		newArray.array[1] = val;
	}
	return [[CLJPersistentArrayMap alloc] initWithArray:newArray];
}

- (id<CLJIAssociative>)associateKey:(id)key withValue:(id)val {
	NSInteger i = [self indexOf:key];
	CLJArray newArray;
	if (i >= 0) { //already have key, same-sized replacement
		if (_array.array[i + 1] == val) { //no change, no op
			return self;
		}
		newArray = CLJArrayCreateCopy(_array);
		newArray.array[i + 1] = val;
	} else { //didn't have key, grow
		if (_array.length > HASHTABLE_THRESHOLD) {
			return [[self createHT:_array] associateKey:key withValue:val];
		}
		newArray = CLJArrayCreate(_array.length + 2);
		if (_array.length > 0) {
			CLJArrayCopy(_array, 0, newArray, 2, _array.length);
		}
		newArray.array[0] = key;
		newArray.array[1] = val;
	}
	return [[CLJPersistentArrayMap alloc] initWithArray:newArray];
}

- (id<CLJIPersistentMap>)without:(id)key {
	NSInteger i = [self indexOf:key];
	if (i >= 0) { //have key, will remove
		NSInteger newlen = _array.length - 2;
		if (newlen == 0) {
			return (id<CLJIPersistentMap>)self.empty;
		}
		CLJArray newArray = CLJArrayCreate(newlen);
		for (NSUInteger s = 0, d = 0; s < _array.length; s += 2) {
			if (![CLJPersistentArrayMap equalKey:_array.array[s] other:key]) { //skip removal key
				newArray.array[d] = _array.array[s];
				newArray.array[d + 1] = _array.array[s + 1];
				d += 2;
			}
		}
		return [[CLJPersistentArrayMap alloc] initWithArray:newArray];
	}
	//don't have key, no op
	return self;
}

- (id<CLJIPersistentCollection>)empty {
	return (id<CLJIPersistentMap>)[EMPTY withMeta:self.meta];
}

- (id)objectForKey:(id)key default:(id)notFound {
	NSInteger i = [self indexOf:key];
	if (i >= 0) {
		return _array.array[i + 1];
	}
	return notFound;
}

- (id)objectForKey:(id)key {
	return [self objectForKey:key default:nil];
}

- (NSUInteger)capacity {
	return self.count;
}

- (NSInteger)indexOfObject:(id)key {
    for (int i = 0; i < _array.length; i += 2) {
        if ([_array.array[i] isEqual:key]) {
            return i;
		}
	}
	return NSNotFound;
}

- (NSInteger)indexOf:(id)key {
	return [self indexOfObject:key];
}

+ (BOOL)equalKey:(id)k1 other:(id)k2 {
//    if ([k1 isKindOfClass:CLJKeyword.class])
//        return k1 == k2;
	return [CLJUtils equiv:(__bridge void *)(k1) other:(__bridge void *)(k2)];
}

- (NSEnumerator *)objectEnumerator {
//	return new Iter(array);
	return nil;
}

- (id<CLJISeq>)seq {
	if (_array.length > 0) {
		return [CLJSeq create:_array];
	}
	return nil;
}

- (id<CLJIPersistentMap>)meta {
	return _meta;
}

- (id)kvreduce:(CLJIKeyValueReduceBlock)f init:(id)init {
	for (int i=0;i < _array.length;i+=2){
		init = f(init, _array.array[i], _array.array[i+1]);
		if ([CLJUtils isReduced:init]) {
			return ((id<CLJIDeref>)init).deref;
		}
	}
	return init;
}

- (id<CLJITransientCollection>)asTransient {
	return [[CLJTransientArrayMap alloc] initWithArray:_array];
}

@end
