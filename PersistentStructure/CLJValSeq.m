//
//  CLJValSeq.m
//  PersistentStructure
//
//  Created by Robert Widmann on 3/28/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJValSeq.h"
#import "CLJKeySeq.h"
#import "CLJInterfaces.h"

@implementation CLJValSeq {
	id<CLJISeq> _seq;
}

+ (CLJValSeq *)create:(id<CLJISeq>)seq {
	if (seq == nil) {
		return nil;
	}
	return [[CLJValSeq alloc] initWithSeq:seq];
}

- (instancetype)initWithSeq:(id<CLJISeq>)seq{
	self = [super init];
	
	_seq = seq;
	
	return self;
}

- (instancetype)initWithMeta:(id<CLJIPersistentMap>)meta seq:(id<CLJISeq>)seq {
	self = [super initWithMeta:meta];
	
	_seq = seq;
	
	return self;
}

- (id)first {
	return ((id<CLJIMapEntry>)_seq.first).getValue;
}

- (id<CLJISeq>)next {
	return [CLJValSeq create:_seq.next];
}

- (CLJValSeq *)withMeta:(id<CLJIPersistentMap>)meta {
	return [[CLJValSeq alloc] initWithMeta:meta seq:_seq];
}

@end
