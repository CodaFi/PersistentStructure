//
//  CLJLazySeq.m
//  PersistentStructure
//
//  Created by Robert Widmann on 12/29/13.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJLazySeq.h"
#import "CLJAbstractObject.h"
#import "CLJPersistentList.h"
#import "CLJICollection.h"
#import "CLJISeq.h"
#import "CLJIPersistentCollection.h"
#import "CLJUtils.h"
#import "CLJSeqIterator.h"

@implementation CLJLazySeq {
	CLJLazySeqGenerator _generatorFunction;
	id _secondValue;
	id<CLJISeq> _backingSeq;
}

-(id)initWithGenerator:(CLJLazySeqGenerator)g {
	self = [super init];
	_generatorFunction = g;
	return self;
}

- (id)initWithMeta:(id<CLJIPersistentMap>)meta seq:(id<CLJISeq>)seq {
	self = [super init];
	
	_meta = meta;
	_generatorFunction = nil;
	_backingSeq = seq;
	
	return self;
}

- (id)withMeta:(id<CLJIPersistentMap>)meta {
	return [[CLJLazySeq alloc] initWithMeta:meta seq:self.seq];
}

- (id)sval {
	@synchronized(self) {
		if (_generatorFunction != nil) {
			_secondValue = _generatorFunction();
			_generatorFunction = nil;
		}
	}
	if (_secondValue != nil) {
		return _secondValue;
	}
	return _backingSeq;
}

- (id<CLJISeq>)seq {
	@synchronized(self) {
		[self sval];
		if (_secondValue != nil) {
			id ls = _secondValue;
			_secondValue = nil;
			while([ls isKindOfClass:CLJLazySeq.class]) {
				ls = ((CLJLazySeq *)ls).sval;
			}
			_backingSeq = [CLJUtils seq:ls];
		}
	}
	return _backingSeq;
}

- (NSUInteger)count {
	NSInteger c = 0;
	for (id<CLJISeq> s = self.seq; s != nil; s = s.next) {
		++c;
	}
	return c;
}

- (id)first {
	[self seq];
	if (_backingSeq == nil) {
		return nil;
	}
	return _backingSeq.first;
}

- (id<CLJISeq>)next {
	[self seq];
	if (_backingSeq == nil) {
		return nil;
	}
	return _backingSeq.next;
}

- (id<CLJISeq>)more {
	[self seq];
	if (_backingSeq == nil) {
		return (id<CLJISeq>)CLJPersistentList.empty;
	}
	return _backingSeq.more;
}

- (id<CLJISeq>)cons:(id)o {
	return [CLJUtils cons:o to:self.seq];
}

- (id<CLJIPersistentCollection>)empty {
	return CLJPersistentList.empty;
}

- (BOOL)equiv:(id)o {
	return [self isEqual:o];
}

- (NSUInteger)hash {
	id<CLJISeq> s = self.seq;
	if (s == nil)
		return 1;
	return [CLJUtils hash:self.seq];;
}

- (NSInteger)hasheq {
	id<CLJISeq> s = self.seq;
	if (s == nil)
		return 1;
	return [CLJUtils hasheq:self.seq];
}

- (BOOL)isEqual:(id)o {
	id<CLJISeq> s = self.seq;
	if (s != nil) {
		return [s equiv:o];
	} else {
		return ([o conformsToProtocol:@protocol(CLJISequential)] || [o conformsToProtocol:@protocol(CLJIList)]) && [CLJUtils seq:o] == nil;
	}
}


// java.util.Collection implementation

- (CLJArray)toArray{
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

- (BOOL)isEmpty {
	return self.seq == nil;
}

- (BOOL)containsObject:(id)o {
	for (id<CLJISeq> s = self.seq; s != nil; s = s.next) {
		if ([CLJUtils equiv:(__bridge void *)(s.first) other:(__bridge void *)(o)]) {
			return YES;
		}
	}
	return NO;
}

- (NSEnumerator *)objectEnumerator {
	return [[CLJSeqIterator alloc] initWithSeq:self.seq];
}

//////////// List stuff /////////////////
- (id<CLJIList>)reify {
//	return new ArrayList(this);
	return nil;
}

- (id<CLJIList>)subListFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
	return [self.reify subListFromIndex:fromIndex toIndex:toIndex];
}

- (id)set:(NSInteger)index element:(id)element {
	CLJRequestConcreteImplementation(self, _cmd, Nil);
	return nil;
}

- (NSInteger)indexOf:(id)o {
	id<CLJISeq> s = self.seq;
	for (NSInteger i = 0; s != nil; s = s.next, i++) {
		if ([CLJUtils equiv:(__bridge void *)(s.first) other:(__bridge void *)(o)])
			return i;
	}
	return -1;
}

- (NSInteger)lastIndexOf:(id)o {
	return [self.reify lastIndexOf:o];
}

- (id)get:(NSInteger)index {
	return [CLJUtils nthOf:self index:index];
}

- (BOOL)isRealized {
	return _generatorFunction == nil;
}

@end
