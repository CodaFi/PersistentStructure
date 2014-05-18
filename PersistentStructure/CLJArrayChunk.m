//
//  CLJArrayChunk.m
//  PersistentStructure
//
//  Created by Robert Widmann on 3/26/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJArrayChunk.h"
#import "CLJUtils.h"

@implementation CLJArrayChunk {
	CLJArray _array;
	NSInteger _off;
	NSInteger _end;
}

- (id)initWithArray:(CLJArray)array {
	return [self initWithArray:array offset:0 end:array.length];
}

- (id)initWithArray:(CLJArray)array offset:(NSInteger)offset {
	return [self initWithArray:array offset:offset end:array.length];
}

- (id)initWithArray:(CLJArray)array offset:(NSInteger)offset end:(NSInteger)end {
	self = [super init];
	
	_array = array;
	_off = offset;
	_end = end;
	
	return self;
}

-(id)nth:(NSInteger)i {
	return _array.array[_off + i];
}

- (id)nth:(NSInteger)i default:(id)notFound {
	if (i >= 0 && i < self.count) {
		return [self nth:i];
	}
	return notFound;
}

- (NSUInteger)count {
	return _end - _off;
}

- (id<CLJIChunk>)tail {
	if (_off==_end) {
		@throw [NSException exceptionWithName:@"IllegalStateException" reason:@"tail of empty chunk" userInfo:nil];
	}
	return [[CLJArrayChunk alloc] initWithArray:_array offset:_off + 1 end:_end];
}

- (id)reduce:(CLJIReduceBlock)f start:(id)start {
	id ret = f(start, _array.array[_off]);
	if ([CLJUtils isReduced:ret])
		return ret;
	for (NSInteger x = _off + 1; x < _end; x++) {
		ret = f(ret, _array.array[x]);
		if ([CLJUtils isReduced:ret]) {
			return ret;
		}
	}
	return ret;
}

@end
