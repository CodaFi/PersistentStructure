//
//  CLJVecSeq.m
//  PersistentStructure
//
//  Created by Robert Widmann on 3/26/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJVecSeq.h"
#import "CLJInterfaces.h"

@implementation CLJVecSeq {
	id<CLJIPersistentVector> _vector;
	NSInteger _index;
}

- (id)initWithVector:(id<CLJIPersistentVector>)v index:(NSInteger)i {
	self = [super init];
	
	_vector = v;
	_index = i;
	
	return self;
}

- (id)initWithMeta:(id<CLJIPersistentMap>)meta vector:(id<CLJIPersistentVector>)v index:(NSInteger)i {
	self = [super initWithMeta:meta];
	
	_vector = v;
	_index = i;
	
	return self;
}

- (id)first {
	return [_vector objectAtIndex:_index];
}

- (id<CLJISeq>)next {
	if (_index + 1 < _vector.count)
		return [[CLJVecSeq alloc] initWithVector:_vector index:_index + 1];
	return nil;
}

- (NSInteger)index {
	return _index;
}

- (NSUInteger)count {
	return _vector.count - _index;
}

- (id)withMeta:(id<CLJIPersistentMap>)meta {
	return [[CLJVecSeq alloc] initWithMeta:meta vector:_vector index:_index];
}

- (id)reduce:(CLJIReduceBlock)f {
	id ret = [_vector objectAtIndex:_index];
	for (NSInteger x = _index + 1; x < _vector.count; x++) {
		ret = f(ret, [_vector objectAtIndex:x]);
	}
	return ret;
}

- (id)reduce:(CLJIReduceBlock)f start:(id)start {
	id ret = f(start, [_vector objectAtIndex:_index]);
	for (NSInteger x = _index + 1; x < _vector.count; x++) {
		ret = f(ret, [_vector objectAtIndex:x]);
	}
	return ret;
}

@end
