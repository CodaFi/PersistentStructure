//
//  CLJQueueSeq.m
//  PersistentStructure
//
//  Created by IDA WIDMANN on 6/24/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//

#import "CLJQueueSeq.h"
#import "CLJUtils.h"

@implementation CLJQueueSeq {
	id<CLJISeq> _f;
	id<CLJISeq> _rseq;
}

- (id)initWithFirst:(id<CLJISeq>)f rev:(id<CLJISeq>)rseq {
	self = [super init];
	
	_f = f;
	_rseq = rseq;
	
	return self;
}

- (instancetype)initWithMeta:(id<CLJIPersistentMap>)meta first:(id<CLJISeq>)f rev:(id<CLJISeq>)rseq {
	self = [super initWithMeta:meta];
	
	_f = f;
	_rseq = rseq;
	
	return self;
}

- (id)first {
	return _f.first;
}

- (id<CLJISeq>)next {
	id<CLJISeq> f1 = _f.next;
	id<CLJISeq> r1 = _rseq;
	if (f1 == nil) {
		if (_rseq == nil) {
			return nil;
		}
		f1 = _rseq;
		r1 = nil;
	}
	return [[CLJQueueSeq alloc] initWithFirst:f1 rev:r1];
}

- (NSUInteger)count {
	return [CLJUtils count:_f] + [CLJUtils count:_rseq];
}

- (id<CLJISeq>)withMeta:(id<CLJIPersistentMap>)meta {
	return [[CLJQueueSeq alloc] initWithMeta:meta first:_f rev:_rseq];
}

@end
