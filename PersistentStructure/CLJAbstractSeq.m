//
//  _CLJSeq.m
//  PersistentStructure
//
//  Created by Robert Widmann on 12/29/13.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJAbstractSeq.h"
#import "CLJAbstractObject.h"
#import "CLJIPersistentCollection.h"
#import "CLJISequential.h"
#import "CLJICollection.h"
#import "CLJIList.h"
#import "CLJICounted.h"
#import "CLJISeq.h"
#import "CLJISeqable.h"
#import "CLJIHashEq.h"
#import "CLJAbstractCons.h"
#import "CLJPersistentList.h"
#import "CLJUtils.h"
#import "CLJSeqIterator.h"

@implementation CLJAbstractSeq {
	NSInteger _hash;
	NSInteger _hasheq;
	CLJSeqIterator *_it;
}

- (id)init {
	self = [super init];
	
	_hash = -1;
	_hasheq = -1;
	
	return self;
}

- (id<CLJIPersistentCollection>)empty {
	return CLJPersistentList.empty;
}

- (instancetype)initWithMeta:(id<CLJIPersistentMap>)meta {
	self = [super init];
	
	_meta = meta;
	
	return self;
}

- (BOOL)equiv:(id)obj {
	if (!([obj conformsToProtocol:@protocol(CLJISequential)] || [obj conformsToProtocol:@protocol(CLJIList)])) {
		return NO;
	}
	id<CLJISeq> ms = [CLJUtils seq:obj];
	for (id<CLJISeq> s = self.seq; s != nil; s = s.next, ms = ms.next) {
		if (ms == nil || ![CLJUtils equiv:(__bridge void *)(s.first) other:(__bridge void *)(ms.first)]) {
			return NO;
		}
	}
	return ms == nil;
}

- (BOOL)isEqual:(id)obj {
	if (self == obj) return true;
	if (!([obj conformsToProtocol:@protocol(CLJISequential)] || [obj conformsToProtocol:@protocol(CLJIList)])) {
		return NO;
	}
	id<CLJISeq> ms = [CLJUtils seq:obj];
	for (id<CLJISeq> s = self.seq; s != nil; s = s.next, ms = ms.next) {
		if (ms == nil || ![CLJUtils isEqual:s.first other:ms.first]) {
			return NO;
		}
	}
	return ms == nil;
}

- (NSUInteger)hash {
	if (_hash == -1) {
		NSInteger hash = 1;
		for (id<CLJISeq> s = self.seq; s != nil; s = s.next) {
			hash = 31 * hash + (s.first == nil ? 0 : [s.first hash]);
		}
		_hash = hash;
	}
	return _hash;
}

- (NSInteger)hasheq {
	if (_hasheq == -1) {
		NSInteger hash = 1;
		for (id<CLJISeq> s = self.seq; s != nil; s = s.next) {
			hash = 31 * hash + [CLJUtils hasheq:s.first];
		}
		_hasheq = hash;
	}
	return _hasheq;
}


//public Object reduce(IFn f) {
//        Object ret = first();
//        for (ISeq s = rest(); s != null; s = s.rest())
//                ret = f.invoke(ret, s.first());
//        return ret;
//}
//
//public Object reduce(IFn f, Object start) {
//        Object ret = f.invoke(start, first());
//        for (ISeq s = rest(); s != null; s = s.rest())
//                ret = f.invoke(ret, s.first());
//        return ret;
//}

//public Object peek(){
//        return first();
//}
//
//public IPersistentList pop(){
//        return rest();
//}

- (NSUInteger)count {
	NSUInteger i = 1;
	for (id<CLJISeq> s = self.next; s != nil; s = s.next, i++) {
		if ([s conformsToProtocol:@protocol(CLJICounted)]) {
			return i + s.count;
		}
	}
	return i;
}

- (id<CLJISeq>)seq {
	return self;
}

- (id<CLJISeq>)cons:(id)o {
	return [[CLJAbstractCons alloc] initWithFirst:o rest:self];
}

- (id<CLJISeq>)more {
	id<CLJISeq> s = self.next;
	if (s == nil) {
		return (id<CLJISeq>)CLJPersistentList.empty;
	}
	return s;
}

//final public ISeq rest(){
//    Seqable m = more();
//    if (m == null)
//        return null;
//    return m.seq();
//}

// java.util.Collection implementation

- (CLJArray)toArray {
	return [CLJUtils seqToArray:self.seq];
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
	return [[CLJSeqIterator alloc] initWithSeq:self];
}

//////////// List stuff /////////////////
- (id<CLJIList>)reify {
//	return Collections.unmodifiableList(@[self]);
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
		if ([CLJUtils equiv:(__bridge void *)(s.first) other:(__bridge void *)(o)]) {
			return i;
		}
	}
	return NSNotFound;
}

- (NSInteger)lastIndexOf:(id)o {
	return [self.reify lastIndexOf:o];
}

- (id)get:(NSInteger)index {
	return [CLJUtils nthOf:self index:index];
}

#pragma mark - Abstract

- (void)add:(NSInteger)index element:(id)element{ }

- (id)first {
	return nil;
}

- (id<CLJISeq>)next {
	return nil;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id [])buffer count:(NSUInteger)len {
	if (!_it) {
		_it = [[CLJSeqIterator alloc] initWithSeq:self];
	}
	return [_it countByEnumeratingWithState:state objects:buffer count:len];
}

@end
