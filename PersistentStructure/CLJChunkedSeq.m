//
//  CLJChunkedSeq.m
//  PersistentStructure
//
//  Created by Robert Widmann on 3/26/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJChunkedSeq.h"
#import "CLJPersistentVector.h"
#import "CLJArrayChunk.h"
#import "CLJChunkedSeq.h"
#import "CLJPersistentList.h"

@implementation CLJChunkedSeq {
	CLJPersistentVector *_vec;
	CLJArray _node;
	NSInteger _i;
	NSInteger _offset;
}

- (id)initWithVec:(CLJPersistentVector *)vec index:(NSInteger)i offset:(NSInteger)offset {
	self = [super init];
	
	_vec = vec;
	_i = i;
	_offset = offset;
	_node = [vec arrayFor:i];
	
	return self;
}

- (id)initWithMeta:(id<CLJIPersistentMap>)meta vec:(CLJPersistentVector *)vec node:(CLJArray)node index:(NSInteger)i offset:(NSInteger)offset {
	self = [super initWithMeta:meta];
	
	_vec = vec;
	_i = i;
	_offset = offset;
	_node = node;
	
	return self;
}

- (id)initWithVec:(CLJPersistentVector *)vec node:(CLJArray)node index:(NSInteger)i offset:(NSInteger)offset {
	self = [super init];
	
	_vec = vec;
	_i = i;
	_offset = offset;
	_node = node;
	
	return self;
}

- (id<CLJIChunk>)chunkedFirst {
	return [[CLJArrayChunk alloc] initWithArray:_node offset:_offset];
}


- (id<CLJISeq>)chunkedNext {
	if (_i + _node.length < _vec.count) {
		return [[CLJChunkedSeq alloc] initWithVec:_vec index:_node.length offset:0];
	}
	return nil;
}

- (id<CLJISeq>)chunkedMore {
	id<CLJISeq> s = self.chunkedNext;
	if (s == nil) {
		return (id<CLJISeq>)CLJPersistentList.empty;
	}
	return s;
}

- (id)withMeta:(id<CLJIPersistentMap>)meta {
	if (meta == _meta) {
		return self;
	}
	return [[CLJChunkedSeq alloc] initWithMeta:meta vec:_vec node:_node index:_i offset:_offset];
}

- (id)first {
	return _node.array[_offset];
}

- (id<CLJISeq>)next {
	if (_offset + 1 < _node.length) {
		return [[CLJChunkedSeq alloc] initWithVec:_vec node:_node index:_i offset:_offset + 1];
	}
	return self.chunkedNext;
}

- (NSUInteger)count {
	return _vec.count - (_i + _offset);
}

@end
