//
//  CLJICollection.h
//  PersistentStructure
//
//  Created by Robert Widmann on 12/29/13.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJArray.h"
#import "CLJICounted.h"

/// The CLJICollection protocol declares the methods necessary for an object to call itself a
/// collection.
///
/// The Collection interface is written so as to be as general as possible.  The implementation of
/// the collection determines whether that collection is ordered or unordered, unique or
/// heterogenous, etc.  What is known is that all collections are traversible through fast
/// enumeration and that they know the count of their objects.
@protocol CLJICollection <NSObject, NSFastEnumeration, CLJICounted>

/// Returns a Boolean value that indicates whether the receiver and a given object are equal.
- (BOOL)containsObject:(id)anObject;

/// Returns a Boolean value that indicates whether the reciever is empty.
- (BOOL)isEmpty;

/// Returns an enumerator object that lets you access each object in the collection once.
- (NSEnumerator *)objectEnumerator;

/// Converts a collection
- (CLJArray)toArray;

@end
