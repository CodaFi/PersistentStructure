//
//  _CLJPersistentVector.m
//  PersistentStructure
//
//  Created by Robert Widmann on 12/30/13.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJPersistentVector.h"
#import "CLJVectorListIterator.h"
#import "CLJAbstractObject.h"
#import "CLJIPersistentCollection.h"
#import "CLJISeq.h"
#import "CLJIIndexed.h"
#import "CLJISeqable.h"
#import "CLJILookup.h"
#import "CLJIMapEntry.h"
#import "CLJISequential.h"
#import "CLJICollection.h"
#import "CLJIPersistentStack.h"
#import "CLJIIndexedSeq.h"
#import "CLJIReduce.h"
#import "CLJIObj.h"
#import "CLJSeq.h"
#import "CLJMapEntry.h"
#import "CLJVecSeq.h"
#import "CLJRVecSeq.h"
#import "CLJUtils.h"

@implementation CLJAbstractPersistentVector {
	NSInteger _hash;
	NSInteger _hasheq;
}

- (id)init {
	self = [super init];
	_hash = -1;
	_hasheq = -1;
	return self;
}

- (id<CLJISeq>)seq {
	if (self.count > 0) {
		return [[CLJVecSeq alloc] initWithVector:self index:0];
	}
	return nil;
}

- (id<CLJISeq>)rseq {
	if (self.count > 0) {
		return [[CLJRVecSeq alloc] initWithVector:self index:self.count - 1];
	}
	return nil;
}

+ (BOOL)doisEqual:(id<CLJIPersistentVector>)v object:(id)obj {
	if (v == obj) return true;
	
	if ([obj conformsToProtocol:@protocol(CLJIList)] || [obj conformsToProtocol:@protocol(CLJIPersistentVector)]) {
		id<CLJICollection> ma = (id<CLJICollection>) obj;
		if (ma.count != v.count || [ma hash] != [v hash]) {
			return NO;
		}
		id objec;
		for (NSEnumerator *i1 = ((id<CLJIList>)v).objectEnumerator, *i2 = ma.objectEnumerator; objec != nil;) {
			objec = i1.nextObject;
			if (![CLJUtils isEqual:objec other:i2.nextObject]) {
				return NO;
			}
		}
		return YES;
	} else {
		if (![obj conformsToProtocol:@protocol(CLJISequential)]) {
			return NO;
		}
		id<CLJISeq> ms = [CLJUtils seq:obj];
		for (NSInteger i = 0; i < v.count; i++, ms = ms.next) {
			if (ms == nil || ![CLJUtils isEqual:[v nth:i] other:ms.first]) {
				return NO;
			}
		}
		if (ms != nil) {
			return NO;
		}
	}
	return YES;
}

+ (BOOL)doEquiv:(id<CLJIPersistentVector>)v object:(id)obj {
	if ([obj conformsToProtocol:@protocol(CLJIList)] || [obj conformsToProtocol:@protocol(CLJIPersistentVector)]) {
		id<CLJICollection> ma = (id<CLJICollection>) obj;
		if (ma.count != v.count) {
			return NO;
		}
		id objec;
		for (NSEnumerator *i1 = ((id<CLJIList>)v).objectEnumerator, *i2 = ma.objectEnumerator; objec != nil;) {
			objec = i1.nextObject;
			if (![CLJUtils equiv:(__bridge void *)(objec) other:(__bridge void *)(i2.nextObject)]) {
				return NO;
			}
		}
		return YES;
	} else {
		if (![obj conformsToProtocol:@protocol(CLJISequential)]) {
			return NO;
		}
		id<CLJISeq> ms = [CLJUtils seq:obj];
		for (NSInteger i = 0; i < v.count; i++, ms = ms.next) {
			if (ms == nil || ![CLJUtils equiv:(__bridge void *)([v nth:i]) other:(__bridge void *)(ms.first)]) {
				return NO;
			}
		}
		if (ms != nil) {
			return NO;
		}
	}
	return YES;
}

- (BOOL)isEqual:(id)o {
	return [CLJAbstractPersistentVector doisEqual:self object:o];
}

- (BOOL)equiv:(id)o {
	return [CLJAbstractPersistentVector doEquiv:self object:o];
}

- (NSUInteger)hash {
	if (_hash == -1) {
		NSUInteger hash = 1;
		NSEnumerator *i = self.objectEnumerator;
		id obj;
		while((obj = i.nextObject) != nil) {
			hash = 31 * hash + (obj == nil ? 0 : [obj hash]);
		}
		_hash = hash;
	}
	return _hash;
}

- (NSInteger)hasheq {
	if (_hasheq == -1) {
		NSInteger hash = 1;
		NSEnumerator *i = self.objectEnumerator;
		id obj;
		while((obj = i.nextObject) != nil) {
			hash = 31 * hash + [CLJUtils hasheq:obj];
		}
		_hasheq = hash;
	}
	return _hasheq;
}

- (id)get:(NSInteger)index {
	return [self nth:index];
}

- (id)nth:(NSInteger)i default:(id)notFound {
	if (i >= 0 && i < self.count) {
		return [self nth:i];
	}
	return notFound;
}

- (NSInteger)indexOf:(id)o {
	for (NSInteger i = 0; i < self.count; i++) {
		if ([CLJUtils equiv:(__bridge void *)([self nth:i]) other:(__bridge void *)(o)]) {
			return i;
		}
	}
	return -1;
}

- (NSInteger)lastIndexOf:(id)o {
	for (NSInteger i = self.count - 1; i >= 0; i--) {
		if ([CLJUtils equiv:(__bridge void *)([self nth:i]) other:(__bridge void *)(o)]) {
			return i;
		}
	}
	return -1;
}

- (id<CLJIList>)subListFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
	return (id<CLJIList>)[CLJUtils subvecOf:self start:fromIndex end:toIndex];
}

- (id)set:(NSInteger)index element:(id)element {
	CLJRequestConcreteImplementation(self, _cmd, Nil);
	return nil;
}

- (id)peek {
	if (self.count > 0) {
		return [self nth:self.count - 1];
	}
	return nil;
}

- (BOOL)containsKey:(id)key {
	if (![CLJUtils isInteger:key]) {
		return NO;
	}
	NSInteger i = ((NSNumber *)key).integerValue;
	return i >= 0 && i < self.count;
}

- (id<CLJIMapEntry>)objectForKey:(id)key {
	if (![CLJUtils isInteger:key]) {
		NSInteger i = ((NSNumber *) key).integerValue;
		if (i >= 0 && i < self.count) {
			return [[CLJMapEntry alloc] initWithKey:key val:[self nth:i]];
		}
	}
	return nil;
}

- (id<CLJIPersistentVector>)associateKey:(id)key withValue:(id)val {
	if (![CLJUtils isInteger:key]) {
		NSInteger i = ((NSNumber *) key).integerValue;
		return [self assocN:i value:val];
	}
	NSAssert(0, @"Key must be integer");
	return nil;
}

- (id)valAt:(id)key default:(id)notFound {
	if ([CLJUtils isInteger:key]) {
		NSInteger i = ((NSNumber *) key).integerValue;
		if (i >= 0 && i < self.count) {
			return [self nth:i];
		}
	}
	return notFound;
}

- (id)valAt:(id)key {
	return [self valAt:key default:nil];
}

// java.util.Collection implementation

- (CLJArray)toArray {
	return [CLJUtils seqToArray:self.seq];
}

- (BOOL)containsAll:(id<CLJICollection>)c {
	for (id o in c) {
		if (![self containsObject:o]) {
			return NO;
		}
	}
	return YES;
}

- (NSUInteger)count {
	return 0;
}

- (BOOL)isEmpty {
	return self.count == 0;
}

- (BOOL)containsObject:(id)o {
	for (id<CLJISeq> s = self.seq; s != nil; s = s.next) {
		if ([CLJUtils equiv:(__bridge void *)(s.first) other:(__bridge void *)(o)]) {
			return YES;
		}
	}
	return NO;
}

- (NSInteger)length {
	return self.count;
}

- (NSComparisonResult)compareTo:(id)o {
	id<CLJIPersistentVector> v = (id<CLJIPersistentVector>) o;
	if (self.count < v.count) {
		return -1;
	} else if (self.count > v.count) {
		return 1;
	}
	
	for (NSInteger i = 0; i < self.count; i++) {
		NSComparisonResult c = [CLJUtils compare:[self nth:i] to:[v nth:i]];
		if (c != 0) {
			return c;
		}
	}
	return NSOrderedSame;
}

#pragma mark - Abtract

- (id<CLJIPersistentVector>)assocN:(NSInteger)i value:(id)val {
	return nil;
}

- (id<CLJIPersistentVector>)cons:(id)o {
	return nil;
}

- (id<CLJIPersistentCollection>)empty {
	return nil;
}

- (id<CLJIPersistentStack>)pop {
	return nil;
}

- (id)nth:(NSInteger)i {
	return nil;
}

- (NSEnumerator *)objectEnumerator {
	return [[CLJVectorListIterator alloc] initWithVector:self index:0];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id [])buffer count:(NSUInteger)len {
	return 0;
}

@end
