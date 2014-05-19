//
//  CLJVectorListIterator.m
//  PersistentStructure
//
//  Created by Robert Widmann on 5/18/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//

#import "CLJVectorListIterator.h"

@implementation CLJVectorListIterator {
	id<CLJIPersistentVector> _vec;
	NSUInteger _index;
}

- (id)initWithVector:(id<CLJIPersistentVector>)vec index:(NSUInteger)index {
	self = [super init];
	
	_vec = vec;
	_index = index;
	
	return self;
}

- (id)nextObject {
	return [_vec nth:_index++];
}

@end
