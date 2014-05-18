//
//  CLJStringSeq.m
//  PersistentStructure
//
//  Created by Robert Widmann on 3/27/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJStringSeq.h"

@implementation CLJStringSeq {
	NSString *_string;
	NSInteger _index;
}

- (id)initWithString:(NSString *)s {
	if (s.length == 0) {
		return nil;
	}
	return [[CLJStringSeq alloc] initWithMeta:nil string:_string index:0];
}

- (id)initWithMeta:(id<CLJIPersistentMap>)meta string:(NSString *)string index:(NSInteger)index {
	self = [super initWithMeta:meta];
	
	_string = string;
	_index = index;
	
	return self;
}

- (id)withMeta:(id<CLJIPersistentMap>)meta{
	if (meta == _meta) {
		return self;
	}
	return [[CLJStringSeq alloc] initWithMeta:meta string:_string index:_index];
}

- (id)first {
	return @([_string characterAtIndex:_index]);
}

- (id<CLJISeq>)next {
	if (_index + 1 < _string.length) {
		return [[CLJStringSeq alloc] initWithMeta:_meta string:_string index:_index + 1];
	}
	return nil;
}

- (NSInteger)index {
	return _index;
}

- (NSUInteger)count {
	return _string.length - _index;
}

@end
