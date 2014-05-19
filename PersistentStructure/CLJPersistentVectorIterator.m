//
//  CLJPersistentVectorIterator.m
//  PersistentStructure
//
//  Created by Robert Widmann on 5/18/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//

#import "CLJPersistentVectorIterator.h"

@implementation CLJPersistentVectorIterator {
	CLJPersistentVector *_vec;
	NSUInteger _start;
	NSUInteger _base;
	CLJArray _window;
}

- (id)initWithVector:(CLJPersistentVector *)vec start:(NSUInteger)index {
	self = [super init];
	
	_vec = vec;
	_start = index;
	_base = _start - (_start % 32);
	_window = (_start < _vec.count) ? [_vec arrayFor:_start] : (CLJArray){};
	
	return self;
}

- (id)nextObject {
	if (_start - _start == 32) {
		_window = [_vec arrayFor:_start];
		_base += 32;
	}
	return _window.array[_start++ & 0x01f];
}

@end
