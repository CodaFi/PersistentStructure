//
//  CLJPersistentQueue.m
//  PersistentStructure
//
//  Created by IDA WIDMANN on 6/24/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//

#import "CLJPersistentQueue.h"
#import "CLJPersistentVector.h"
#import "CLJUtils.h"
#import "CLJQueueSeq.h"
#import "CLJSeqIterator.h"

static CLJPersistentQueue *EMPTY;

@implementation CLJPersistentQueue {
	NSInteger _count;
	id<CLJISeq> _front;
	id<CLJIPersistentVector> _rear;
	NSInteger _hash;
	NSInteger _hasheq;
}

+ (void)load {
	if (self.class != CLJPersistentQueue.class) {
		return;
	}
	EMPTY = [[CLJPersistentQueue alloc] initWithMeta:nil count:0 seq:nil rev:nil];
}

- (id)initWithMeta:(id<CLJIPersistentMap>)meta count:(NSInteger)cnt seq:(id<CLJISeq>)f rev:(id<CLJIPersistentVector>)r {
	self = [super initWithMeta:meta];
	
	_count = cnt;
	_front = f;
	_rear = r;
	
	return self;
}

- (BOOL)equiv:(id)obj {
	if (![obj conformsToProtocol:@protocol(CLJISequential)]) {
		return false;
	}
	id<CLJISeq> ms = [CLJUtils seq:obj];
	for(id<CLJISeq> s = self.seq; s != nil; s = s.next, ms = ms.next) {
		if (ms == nil || ![CLJUtils equiv:(__bridge void *)(s.first) other:(__bridge void *)(ms.first)]) {
			return false;
		}
	}
	return ms == nil;
}

- (BOOL)isEqual:(id)obj {
	if (![obj conformsToProtocol:@protocol(CLJISequential)]) {
		return false;
	}
	id<CLJISeq> ms = [CLJUtils seq:obj];
	for(id<CLJISeq> s = self.seq; s != nil; s = s.next, ms = ms.next) {
		if (ms == nil || ![CLJUtils isEqual:(__bridge id)((__bridge void *)(s.first)) other:(__bridge id)((__bridge void *)(ms.first))]) {
			return false;
		}
	}
	return ms == nil;
}

- (NSUInteger)hash {
	if (_hash == -1) {
		NSUInteger hash = 1;
		for(id<CLJISeq> s = self.seq; s != nil; s = s.next) {
			hash = 31 * hash + (s.first == nil ? 0 : [s.first hash]);
		}
		_hash = hash;
	}
	return _hash;
}

- (NSInteger)hasheq {
	if (_hasheq == -1) {
		_hasheq = [CLJMurmur3 hashOrdered:self];
	}
	return _hasheq;
}

- (id)peek {
	return [CLJUtils first:_front];
}

- (id<CLJIPersistentStack>)pop {
	if (_front == nil) { //hmmm... pop of empty queue -> empty queue?
		return self;
	}
	//throw new IllegalStateException("popping empty queue");
	id<CLJISeq> f1 = _front.next;
	id<CLJIPersistentVector> r1 = _rear;
	if (f1 == nil) {
		f1 = [CLJUtils seq:_rear];
		r1 = nil;
	}
	return [[CLJPersistentQueue alloc] initWithMeta:self.meta count:_count - 1 seq:f1 rev:r1];
}

- (NSUInteger)count {
	return _count;
}

- (id<CLJISeq>)seq {
	if (_front == nil) {
		return nil;
	}
	return [[CLJQueueSeq alloc] initWithFirst:_front rev:[CLJUtils seq:_rear]];
}

- (id<CLJIPersistentCollection>)cons:(id)other {
	if (_front == nil)  {   //empty
		return [[CLJPersistentQueue alloc] initWithMeta:self.meta count:_count + 1 seq:[CLJUtils list:other] rev:nil];
	} else {
		return [[CLJPersistentQueue alloc] initWithMeta:self.meta count:_count + 1 seq:_front rev:(_rear != nil ? _rear : [CLJPersistentVector.empty cons:other])];
	}
}

- (id<CLJIPersistentCollection>)empty {
	return (id<CLJIPersistentCollection>)[EMPTY withMeta:self.meta];
}

- (id<CLJIObj>)withMeta:(id<CLJIPersistentMap>)meta {
	return [[CLJPersistentQueue alloc] initWithMeta:meta count:_count seq:_front rev:_rear];
}

- (CLJArray)toArray {
	return [CLJUtils seqToArray:self.seq];
}

- (BOOL)isEmpty {
	return self.count == 0;
}

- (BOOL)containsObject:(id)anObject {
	for(id<CLJISeq> s = self.seq; s != nil; s = s.next) {
		if ([CLJUtils equiv:(__bridge void *)(s.first) other:(__bridge void *)(anObject)]) {
			return true;
		}
	}
	return false;
}

- (NSEnumerator *)objectEnumerator {
	return [[CLJSeqIterator alloc] initWithSeq:self.seq];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id [])buffer count:(NSUInteger)len {
	return [self.objectEnumerator countByEnumeratingWithState:state objects:buffer count:len];
}

@end
