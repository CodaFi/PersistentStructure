//
//  PersistentStructure.m
//  PersistentStructure
//
//  Created by Robert Widmann on 3/27/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "PersistentStructure.h"
#import "CLJInterfaces.h"
#import "CLJLazySeq.h"
#import "CLJUtils.h"
#import "CLJLazilyPersistentVector.h"
#import "CLJPersistentHashMap.h"
#import "CLJPersistentHashSet.h"

id<CLJISeq> CLJCreateLazySeq(id restrict fst, ...) {
	return [[CLJLazySeq alloc] initWithGenerator:^{
		return (id)nil;
	}];
}

id<CLJISeq> CLJCons(id x, id<CLJISeq> seq) {
	return [CLJUtils cons:x to:seq];
}

id<CLJIPersistentCollection> CLJCreateList(id restrict fst, ...) {
	return nil;
}

id CLJFirst(id coll) {
	return [CLJUtils first:coll];
}

id CLJSecond(id coll) {
	return [CLJUtils first:[CLJUtils next:coll]];
}

id CLJFFirst(id coll) {
	return [CLJUtils first:[CLJUtils first:coll]];
}

id CLJNFirst(id coll) {
	return [CLJUtils next:[CLJUtils first:coll]];
}

id (* const CLJFNext)(id coll) = CLJSecond;

id CLJNNext(id coll) {
	return [CLJUtils next:[CLJUtils next:coll]];
}

id<CLJISeq> CLJCreateSeq(id coll) {
	return [CLJUtils seq:coll];
}

NSUInteger CLJCount(id coll) {
	return [CLJUtils count:coll];
}

id CLJOverloadable CLJObjectAtIndex(id coll, NSUInteger index) {
	return [CLJUtils nthOf:coll index:index];
}

id CLJOverloadable CLJObjectAtIndex(id coll, NSUInteger index, id notFound) {
	return [CLJUtils nthOf:coll index:index notFound:notFound];
}

BOOL CLJIsSeq(id coll) {
	return [coll conformsToProtocol:@protocol(CLJISeq)];
}

BOOL CLJIsMap(id coll) {
	return [coll conformsToProtocol:@protocol(CLJIPersistentMap)];
}

BOOL CLJIsVec(id coll) {
	return [coll conformsToProtocol:@protocol(CLJIPersistentVector)];
}

BOOL CLJContains(id coll, id key) {
	return [CLJUtils containsObject:coll key:key];
}


id<CLJISeq> CLJNext(id seq) {
	return [CLJUtils next:seq];
}

id<CLJISeq> CLJRest(id coll) {
	return [CLJUtils more:coll];
}


id<CLJIPersistentCollection> CLJOverloadable CLJConj(id x, id<CLJIPersistentCollection> coll) {
	return [CLJUtils conj:x to:coll];
}

id<CLJIPersistentCollection> CLJOverloadable CLJConj(id<CLJIPersistentCollection> coll, id restrict xs, ...) {
	va_list args;
	va_start(args, xs);
	id obj;
	id<CLJIPersistentCollection> result = nil;
	for (obj = xs; obj != nil; obj = va_arg(args, id)) {
		result = [CLJUtils conj:obj to:result];
	}
	va_end(args);
	return result;
}

id<CLJIPersistentCollection> CLJOverloadable CLJAssoc(id<CLJIPersistentCollection> coll, id key, id val) {
	return [CLJUtils associateKey:key to:val in:coll];
}

id<CLJIPersistentCollection> CLJOverloadable CLJAssoc(id<CLJIPersistentCollection> coll, id restrict k, id restrict kvs, ...) {
	va_list args;
	va_start(args, kvs);
	id<CLJIPersistentCollection> result;
	id key, val;
	for (key = k, val = va_arg(args, id); key != nil && val != nil; key = va_arg(args, id), val = va_arg(args, id)) {
		result = [CLJUtils associateKey:key to:val in:result];
	}
	va_end(args);
	return result;
}

id CLJLast(id coll) {
	if ([coll next]) {
		return CLJLast([coll next]);
	}
	return [coll first];
}

id<CLJISeq> CLJButLast(id coll) {
	id res = nil;
	while ([coll next]) {
		res = [CLJUtils conj:[coll first] to:coll];
		coll = [coll next];
	}
	return [CLJUtils seq:coll];
}

id<CLJIPersistentVector, CLJIEditableCollection> CLJCreateVector(id coll) {
	if (![coll conformsToProtocol:@protocol(CLJICollection)]) {
		return (id<CLJIPersistentVector, CLJIEditableCollection>)[CLJLazilyPersistentVector create:coll];
	}
	return (id<CLJIPersistentVector, CLJIEditableCollection>)[CLJLazilyPersistentVector createOwning:[coll toArray]];
}

id<CLJIPersistentMap, CLJIEditableCollection> CLJCreateHashMap(id coll) {
	if ([coll isEmpty]) {
		return (id<CLJIPersistentMap, CLJIEditableCollection>)[CLJPersistentHashMap empty];
	}
	return (id<CLJIPersistentMap, CLJIEditableCollection>)[CLJPersistentHashMap create:coll];
}

id<CLJIPersistentSet, CLJIEditableCollection> CLJCreateHashSet(id coll) {
	return [CLJPersistentHashSet createWithSeq:coll];
}

id<CLJISet> CLJCreateSet(id coll) {
	return [CLJPersistentHashSet createWithSeq:[CLJUtils seq:coll]];
}

id<CLJITransientCollection> CLJCreateTransient(id<CLJIEditableCollection> coll) {
	return [coll asTransient];
}

id<CLJISet> CLJDisj(id<CLJISet> fromSet, id restrict vals, ...) {
	va_list args;
	va_start(args, vals);
	id obj;
	for (obj = vals; obj != nil; obj = va_arg(args, id)) {
		fromSet = (id<CLJISet>)[(id<CLJIPersistentSet>)fromSet disjoin:obj];
	}
	va_end(args);
	return fromSet;
}

id<CLJIPersistentMap> CLJMetadata(id coll) {
	if ([coll conformsToProtocol:@protocol(CLJIMeta)]) {
		return [coll meta];
	}
	return nil;
}

id<CLJIObj> CLJWithMetadata(id<CLJIObj> obj, id<CLJIPersistentMap> m) {
	return [obj withMeta:m];
}

id<CLJISeq> CLJReduce1f(CLJIReduceFunction reducer, id coll) {
	return CLJReduce1(^id(id a, id b) {
		return reducer(a, b);
	}, coll);
}

extern id<CLJISeq> CLJReducef(CLJIReduceFunction reducer, id coll, id val) {
	return CLJReduce(^id(id a, id b) {
		return reducer(a, b);
	}, coll, val);
}

id<CLJISeq> CLJReduce1(CLJIReduceBlock reducer, id coll) {
	return nil;
}

id<CLJISeq> CLJReduce(CLJIReduceBlock reducer, id coll, id val) {
	return nil;
}

id<CLJISeq> seq_reduce(CLJIReduceBlock f, id coll) {
	return nil;
}


