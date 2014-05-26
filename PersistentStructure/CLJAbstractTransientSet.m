//
//  _CLJTransientSet.m
//  PersistentStructure
//
//  Created by Robert Widmann on 3/28/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJAbstractTransientSet.h"

@implementation CLJAbstractTransientSet

- (id)initWithImplementation:(id<CLJITransientMap>)impl {
	self = [super init];
	
	_impl = impl;
	
	return self;
}

- (NSUInteger)count {
	return _impl.count;
}

- (id<CLJITransientCollection>)conj:(id)val {
	id<CLJITransientMap> m = [_impl associateKey:val value:val];
	if (m != _impl) _impl = m;
	return self;
}

- (BOOL)containsObject:(id)key  {
	return self != [_impl objectForKey:key default:self];
}

- (id<CLJITransientSet>)disjoin:(id)key {
	id<CLJITransientMap> m = [_impl without:key];;
	if (m != _impl) {
		_impl = m;
	}
	return self;
}

- (id)get:(id)key {
	return [_impl objectForKey:key];
}

#pragma mark - Abtract

- (id<CLJIPersistentCollection>)persistent {
	return nil;
}

@end
