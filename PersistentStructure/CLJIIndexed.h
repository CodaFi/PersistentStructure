//
//  CLJIIndexed.h
//  PersistentStructure
//
//  Created by Robert Widmann on 12/29/13.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJICounted.h"

/// The CLJIIndexed protocol declares the methods necessary for an object to permit indexed access
/// to the values it contains.
@protocol CLJIIndexed <CLJICounted>

/// Returns the object located at the specified index.
///
/// For indices out of the range of the collection, this method may throw an exception.
- (id)objectAtIndex:(NSInteger)index;

/// Returns the object located at the specified index, returning a default object an the object
/// doesn't exist at that index.
- (id)objectAtIndex:(NSInteger)index default:(id)notFound;

@end
