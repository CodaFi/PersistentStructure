//
//  CLJICollection.h
//  PersistentStructure
//
//  Created by Robert Widmann on 12/29/13.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJArray.h"

@protocol CLJICollection <NSObject, NSFastEnumeration>

- (BOOL)containsObject:(id)anObject;
- (BOOL)containsAll:(id<CLJICollection>)c;
- (BOOL)isEqual:(id)o;
- (BOOL)isEmpty;
- (NSEnumerator *)objectEnumerator;

/// Returns the count of the members in the collection.
- (NSUInteger)count;

- (CLJArray)toArray;

@end
