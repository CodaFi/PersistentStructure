//
//  CLJNodeSeq.m
//  PersistentStructure
//
//  Created by Robert Widmann on 3/25/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJNodeSeq.h"
#import "CLJInterfaces.h"
#import "CLJMapEntry.h"
#import "CLJUtils.h"

@implementation CLJNodeSeq {
	CLJArray _array;
	NSInteger _startingIndex;
	id<CLJISeq> _backingSeq;
}

- (id)initWithArray:(CLJArray)array {
	return [self initWithArray:array index:0 sequence:nil];
}

- (id)initWithArray:(CLJArray)array index:(NSInteger)index {
	return [self initWithMeta:nil array:array index:index sequence:nil];
}

- (id)initWithArray:(CLJArray)array index:(NSInteger)index sequence:(id<CLJISeq>)seq {
	if (seq != nil) {
		return [[CLJNodeSeq alloc] initWithMeta:nil array:array index:index sequence:seq];
	}
	for (NSInteger j = index; j < array.length; j+=2) {
		if (array.array[j] != nil) {
			return [[CLJNodeSeq alloc] initWithMeta:nil array:array index:j sequence:nil];
		}
		id<CLJINode> node = (id<CLJINode>) array.array[j+1];
		if (node != nil) {
			id<CLJISeq> nodeSeq = [node nodeSeq];
			if (nodeSeq != nil) {
				return [[CLJNodeSeq alloc] initWithMeta:nil array:array index:j + 2 sequence:nodeSeq];
			}
		}
	}
	return nil;
}

- (id)initWithMeta:(id<CLJIPersistentMap>)meta array:(CLJArray)array index:(NSInteger)index sequence:(id<CLJISeq>)seq {
	self = [super initWithMeta:meta];
	
	_array = array;
	_startingIndex = index;
	_backingSeq = seq;
	
	return self;
}

- (instancetype)initWithMeta:(id<CLJIPersistentMap>)meta {
	return [[CLJNodeSeq alloc] initWithMeta:meta array:_array index:_startingIndex sequence:_backingSeq];
}

+ (id)kvreducearray:(CLJArray)array reducer:(CLJIKeyValueReduceBlock)f init:(id)init {
	for (NSInteger j=0;j<array.length;j+=2) {
		if (array.array[j] != nil) {
			init = f(init, array.array[j], array.array[j+1]);
		} else {
			id<CLJINode> node = (id<CLJINode>) array.array[j+1];
			if (node != nil) {
				init = [node kvreduce:f init:init];
			}
		}
		if ([CLJUtils isReduced:init]) {
			return init;
		}
	}
	return init;
}

- (id)first {
	if (_backingSeq != nil) {
		return [_backingSeq first];
	}
	return [[CLJMapEntry alloc] initWithKey:_array.array[_startingIndex] val:_array.array[_startingIndex + 1]];
}

- (id<CLJISeq>)next {
	if (_backingSeq != nil) {
		return [[CLJNodeSeq alloc] initWithArray:_array index:_startingIndex sequence:[_backingSeq next]];
	}
	return [[CLJNodeSeq alloc] initWithArray:_array index:_startingIndex + 2 sequence:nil];
}

@end
