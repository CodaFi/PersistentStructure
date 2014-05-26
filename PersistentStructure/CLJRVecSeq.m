//
//  CLJRVecSeq.m
//  PersistentStructure
//
//  Created by Robert Widmann on 3/27/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJRVecSeq.h"
#import "CLJInterfaces.h"

@implementation CLJRVecSeq {
	id<CLJIPersistentVector> _backingVector;
	NSInteger _startingIndex;
}

- (id)initWithVector:(id<CLJIPersistentVector>)vector index:(NSInteger)index {
	self = [super init];
	
	_backingVector = vector;
	_startingIndex = index;
	
	return self;
}

- (id)initWithMeta:(id<CLJIPersistentMap>)meta vector:(id<CLJIPersistentVector>)vector index:(NSInteger)index {
	self = [super initWithMeta:meta];
	
	_backingVector = vector;
	_startingIndex = index;
	
	return self;
}

- (id)first {
	return [_backingVector objectAtIndex:_startingIndex];
}

- (id<CLJISeq>)next {
	if (_startingIndex > 0) {
		return [[CLJRVecSeq alloc] initWithVector:_backingVector index:_startingIndex - 1];
	}
	return nil;
}

- (NSInteger)index {
	return _startingIndex;
}

- (NSUInteger)count {
	return _startingIndex + 1;
}

- (id)withMeta:(id<CLJIPersistentMap>)meta {
	return [[CLJRVecSeq alloc] initWithMeta:meta vector:_backingVector index:_startingIndex];
}

@end

