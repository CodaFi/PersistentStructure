//
//  CLJSeq.m
//  PersistentStructure
//
//  Created by Robert Widmann on 3/26/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJSeq.h"
#import "CLJInterfaces.h"
#import "CLJUtils.h"

@implementation CLJSeq {
	CLJArray _nodes;
	NSInteger _i;
	id<CLJISeq> _s;
}

+ (id<CLJISeq>)create:(CLJArray)nodes {
	return [CLJSeq createWithMeta:nil nodes:nodes index:0 seq:nil];
}

+ (id<CLJISeq>)createWithMeta:(id<CLJIPersistentMap>)meta nodes:(CLJArray)nodes index:(NSInteger)i seq:(id<CLJISeq>)s {
	if (s != nil) {
		return [CLJSeq createWithMeta:meta nodes:nodes index:i seq:s];
	}
	
	for (NSInteger j = i; j < nodes.length; j++) {
		if (nodes.array[j] != nil) {
			id<CLJISeq> ns = [((id<CLJINode>)nodes.array[j]) nodeSeq];
			if (ns != nil) {
				return [CLJSeq createWithMeta:meta nodes:nodes index:j + 1 seq:ns];
			}
		}
	}
	return nil;
}

- (id)initWithMeta:(id<CLJIPersistentMap>)meta nodes:(CLJArray)nodes index:(NSInteger)i seq:(id<CLJISeq>)seq {
	self = [super initWithMeta:meta];
	
	_nodes = nodes;
	_i = i;
	_s = seq;
	
	return self;
}

- (id)withMeta:(id<CLJIPersistentMap>)meta {
	return [[CLJSeq alloc] initWithMeta:meta nodes:_nodes index:_i seq:_s];
}

- (id)first {
	return _s.first;
}

- (id<CLJISeq>)next {
	return [CLJSeq createWithMeta:nil nodes:_nodes index:_i seq:_s.next];
}

@end
