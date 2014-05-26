//
//  CLJITransientSet.h
//  PersistentStructure
//
//  Created by Robert Widmann on 3/28/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJITransientCollection.h"
#import "CLJICounted.h"

@protocol CLJITransientSet <CLJITransientCollection, CLJICounted>

- (id<CLJITransientSet>)disjoin:(id)key;
- (BOOL)containsObject:(id)key;
- (id)objectForKey:(id)key;

@end
