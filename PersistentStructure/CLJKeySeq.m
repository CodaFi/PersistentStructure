//
//  CLJKeySeq.m
//  PersistentStructure
//
//  Created by Robert Widmann on 3/28/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJKeySeq.h"
#import "CLJInterfaces.h"

@implementation CLJKeySeq {
	id<CLJISeq> _seq;
}

+ (CLJKeySeq *)create:(id<CLJISeq>)seq {
	if (seq == nil) {
		return nil;
	}
	return [[CLJKeySeq alloc] initWithSeq:seq];
}

- (instancetype)initWithSeq:(id<CLJISeq>)seq{
	self = [super init];
	
	_seq = seq;
	
	return self;
}

- (instancetype)initWithMeta:(id<CLJIPersistentMap>)meta seq:(id<CLJISeq>)seq{
	self = [super initWithMeta:meta];
	
	_seq = seq;
	
	return self;
}

- (id)first {
	return ((id<CLJIMapEntry>)_seq.first).key;
}

- (id<CLJISeq>)next {
	return [CLJKeySeq create:_seq.next];
}

- (CLJKeySeq *)withMeta:(id<CLJIPersistentMap>)meta {
	return [[CLJKeySeq alloc] initWithMeta:meta seq:_seq];
}

@end
