//
//  CLJIPersistentSet.h
//  PersistentStructure
//
//  Created by Robert Widmann on 3/28/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJICounted.h"
#import "CLJIPersistentCollection.h"

@protocol CLJIPersistentSet <CLJIPersistentCollection, CLJICounted>

- (id<CLJIPersistentSet>)disjoin:(id)key;
- (BOOL)containsObject:(id)key;
- (id)get:(id)key;

@end
