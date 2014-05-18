//
//  CLJPersistentHashSet.m
//  PersistentStructure
//
//  Created by Robert Widmann on 3/28/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJPersistentHashSet.h"
#import "CLJTransientHashSet.h"
#import "CLJPersistentHashMap.h"
#import "CLJInterfaces.h"

static CLJPersistentHashSet *EMPTY;

@implementation CLJPersistentHashSet {
	id<CLJIPersistentMap> _meta;
}

+ (void)load {
	EMPTY = [[CLJPersistentHashSet alloc]initWithMeta:nil impl:(id<CLJIPersistentMap>)CLJPersistentHashMap.empty];
}

+ (CLJPersistentHashSet *)createWithArray:(CLJArray)init {
	CLJPersistentHashSet * ret = EMPTY;
	for (int i = 0; i < init.length; i++) {
		ret = (CLJPersistentHashSet *)[ret cons:init.array[i]];
	}
	return ret;
}

+ (CLJPersistentHashSet *)createWithList:(id<CLJIList>)init {
	CLJPersistentHashSet * ret = EMPTY;
	for (id key in init) {
		ret = (CLJPersistentHashSet *)[ret cons:key];
	}
	return ret;
}

+ (CLJPersistentHashSet *)createWithSeq:(id<CLJISeq>)items {
	CLJPersistentHashSet * ret = EMPTY;
	for (; items != nil; items = items.next) {
		ret = (CLJPersistentHashSet *)[ret cons:items.first];
	}
	return ret;
}

+ (CLJPersistentHashSet *)createWithCheckArray:(CLJArray)init {
	CLJPersistentHashSet * ret = EMPTY;
	for (int i = 0; i < init.length; i++) {
		ret = (CLJPersistentHashSet *)[ret cons:init.array[i]];
		if (ret.count != i + 1) {
			@throw [NSException exceptionWithName:@"IllegalArgumentException" reason:@"Duplicate key: + init.array[i]" userInfo:nil];
		}
	}
	return ret;
}

+ (CLJPersistentHashSet *)createWithCheckList:(id<CLJIList>)init {
	int i = 0;
	CLJPersistentHashSet * ret = EMPTY;
	for (id key in init) {
		ret = (CLJPersistentHashSet *)[ret cons:key];
		if (ret.count != i + 1) {
			@throw [NSException exceptionWithName:@"IllegalArgumentException" reason:@"Duplicate key: + init.array[i]" userInfo:nil];
		}
		++i;
	}
	return ret;
}

+ (CLJPersistentHashSet *)createWithCheckSeq:(id<CLJISeq>)items {
	CLJPersistentHashSet *ret = EMPTY;
	for (int i=0; items != nil; items = items.next, ++i) {
		ret = (CLJPersistentHashSet *)[ret cons:items.first];
		if (ret.count != i + 1) {
			@throw [NSException exceptionWithName:@"IllegalArgumentException" reason:@"Duplicate key: + init.array[i]" userInfo:nil];
		}
	}
	return ret;
}

- (id)initWithMeta:(id<CLJIPersistentMap>)meta impl:(id<CLJIPersistentMap>)impl {
	self = [super initWithImplementation:impl];
	
	_meta = meta;
	
	return self;
}

- (id<CLJIPersistentSet>)disjoin:(id)key  {
	if ([self containsObject:key]) {
		return [[CLJPersistentHashSet alloc] initWithMeta:self.meta impl:[_impl without:key]];
	}
	return self;
}

- (id<CLJIPersistentSet>)cons:(id)other {
	if ([self containsObject:other]) {
		return self;
	}
	return [[CLJPersistentHashSet alloc] initWithMeta:self.meta impl:[_impl associateKey:0 value:other]];
}

- (id<CLJIPersistentCollection>)empty {
	return (id<CLJIPersistentCollection>)[EMPTY withMeta:self.meta];
}

- (CLJPersistentHashSet *)withMeta:(id<CLJIPersistentMap>)meta {
	return [[CLJPersistentHashSet alloc] initWithMeta:meta impl:_impl];
}

- (id<CLJITransientCollection>)asTransient {
	return [[CLJTransientHashSet alloc] initWithImplementation:(id<CLJITransientMap>)((CLJPersistentHashMap *)_impl).asTransient];
}

- (id<CLJIPersistentMap>)meta {
	return _meta;
}

@end
