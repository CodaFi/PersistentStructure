//
//  CLJTransientHashSet.m
//  PersistentStructure
//
//  Created by Robert Widmann on 3/28/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJTransientHashSet.h"
#import "CLJPersistentHashSet.h"

@implementation CLJTransientHashSet

- (id<CLJIPersistentCollection>)persistent {
	return [[CLJPersistentHashSet alloc] initWithMeta:nil impl:_impl.persistent];
}

@end
