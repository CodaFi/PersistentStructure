//
//  CLJPersistentTreeSet.m
//  PersistentStructure
//
//  Created by IDA WIDMANN on 6/24/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//

#import "CLJPersistentTreeSet.h"
#import "CLJPersistentTreeMap.h"
#import "CLJKeySeq.h"
#import "CLJUtils.h"

static CLJPersistentTreeSet *EMPTY;

@implementation CLJPersistentTreeSet {
	id<CLJIPersistentMap> _meta;
}

+ (void)load {
	if (self.class != CLJPersistentTreeSet.class) {
		return;
	}
	EMPTY = [[CLJPersistentTreeSet alloc] initWithMeta:nil implementation:CLJPersistentTreeMap.empty];
}

+ (CLJPersistentTreeSet *)create:(id<CLJISeq>)items {
	CLJPersistentTreeSet *ret = EMPTY;
	for(; items != nil; items = items.next) {
		ret = (CLJPersistentTreeSet *)[ret cons:items.first];
	}
	return ret;
}

+ (CLJPersistentTreeSet *)create:(CLJComparatorBlock)comparator items:(id<CLJISeq>)items {
	CLJPersistentTreeMap *impl = [[CLJPersistentTreeMap alloc] initWithMeta:nil comparator:comparator];
	CLJPersistentTreeSet *ret = [[CLJPersistentTreeSet alloc] initWithMeta:nil implementation:impl];
	for(; items != nil; items = items.next) {
		ret = (CLJPersistentTreeSet *)[ret cons:items.first];
	}
	return ret;
}

- (id)initWithMeta:(id<CLJIPersistentMap>)meta implementation:(id<CLJIPersistentMap>)impl {
	self = [super initWithImplementation:impl];
	
	_meta = meta;
	
	return self;
}

- (id<CLJIPersistentSet>)disjoin:(id)key {
	if([self containsObject:key]) {
		return [[CLJPersistentTreeSet alloc] initWithMeta:self.meta implementation:[_impl without:key]];
	}
	return self;
}

- (id<CLJIPersistentSet>)cons:(id)other {
	if([self containsObject:other]) {
		return self;
	}
	return [[CLJPersistentTreeSet alloc] initWithMeta:self.meta implementation:[_impl associateKey:other value:other]];
}

- (id<CLJIPersistentCollection>)empty {
	return [[CLJPersistentTreeSet alloc] initWithMeta:self.meta implementation:CLJPersistentTreeMap.empty];
}

- (id<CLJISeq>)reversedSeq {
	return [CLJKeySeq create:[(id<CLJIReversible>)_impl reversedSeq]];
}

- (id<CLJIObj>)withMeta:(id<CLJIPersistentMap>)meta {
	return [[CLJPersistentTreeSet alloc] initWithMeta:meta implementation:_impl];
}

- (CLJComparatorBlock)comparator {
	return ((id<CLJISorted>)_impl).comparator;
}

- (id)entryKey:(id)entry {
	return entry;
}

- (id<CLJISeq>)seq:(BOOL)ascending {
	CLJPersistentTreeMap *m = (CLJPersistentTreeMap *)_impl;
	return [CLJUtils keys:[m seq:ascending]];
}

- (id<CLJISeq>)seqFrom:(id)key ascending:(BOOL)ascending {
	CLJPersistentTreeMap *m = (CLJPersistentTreeMap *)_impl;
	return [CLJUtils keys:[m seqFrom:key ascending:ascending]];
}

- (id<CLJIPersistentMap>)meta {
	return _meta;
}

@end
