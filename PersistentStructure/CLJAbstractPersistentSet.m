//
//  _CLJPersistentSet.m
//  PersistentStructure
//
//  Created by Robert Widmann on 3/28/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJAbstractPersistentSet.h"
#import "CLJUtils.h"
#import "CLJKeySeq.h"
#import "CLJSeqIterator.h"

@implementation CLJAbstractPersistentSet {
	int _hash;
	int _hasheq;
}

- (id)initWithImplementation:(id<CLJIPersistentMap>)impl {
	self = [super init];
	
	_impl = impl;
	
	return self;
}

- (BOOL)containsObject:(id)o {
	return [_impl containsKey:o];
}

- (id)get:(id)key {
	return [_impl objectForKey:key];
}

- (NSUInteger)count {
	return _impl.count;
}

- (id<CLJISeq>)seq {
	return [CLJKeySeq create:self.seq];
}

- (BOOL)isEqual:(id)o {
	return [CLJAbstractPersistentSet setisEqual:self other:o];
}

+ (BOOL)setisEqual:(id<CLJIPersistentSet>)s1 other:(id)obj {
	if (s1 == obj) return YES;
	if (!([obj conformsToProtocol:@protocol(CLJISet)])) {
		return NO;
	}
	id<CLJISet> m = (id<CLJISet>) obj;
	
	if (m.count != s1.count) {
		return NO;
	}
	
	for (id aM in m) {
		if (![s1 containsObject:aM]) {
			return NO;
		}
	}
	
	return YES;
}

- (BOOL)equiv:(id)o {
	return [CLJAbstractPersistentSet setisEqual:self other:o];
}

- (NSUInteger)hash {
	if (_hash == -1) {
		//int hash = count();
		int hash = 0;
		for (id<CLJISeq> s = self.seq; s != nil; s = s.next) {
			id e = s.first;
			//			hash = Util.hashCombine(hash, Util.hash(e));
			hash += [CLJUtils hash:e];
		}
		_hash = hash;
	}
	return _hash;
}

- (NSInteger)hasheq {
	if (_hasheq == -1){
		int hash = 0;
		for (id<CLJISeq> s = self.seq; s != nil; s = s.next) {
			hash += [CLJUtils hasheq:s.first];
		}
		_hasheq = hash;
	}
	return _hasheq;
}

- (CLJArray)toArray {
	return [CLJUtils seqToArray:self.seq];
}

- (BOOL)containsAll:(id<CLJICollection>)c {
	for (id o in c) {
		if (![self containsObject:o]) {
			return false;
		}
	}
	return true;
}

- (BOOL)isEmpty {
	return self.count == 0;
}

- (NSEnumerator *)objectEnumerator {
	return [[CLJSeqIterator alloc] initWithSeq:self.seq];
}

#pragma mark - Abtract

- (id<CLJIPersistentSet>)disjoin:(id)key {
	return nil;
}

- (id<CLJIPersistentCollection>)cons:(id)other {
	return nil;
}

- (id<CLJIPersistentCollection>)empty {
	return nil;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id [])buffer count:(NSUInteger)len {
	return 0;
}

@end
