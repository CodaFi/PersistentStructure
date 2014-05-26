//
//  CLJIAssociative.h
//  PersistentStructure
//
//  Created by Robert Widmann on 12/29/13.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJIPersistentCollection.h"
#import "CLJILookup.h"
#import "CLJIMapEntry.h"

/// The CLJIAssociative protocol declares the three methods that a class must implement so instances
/// of that class 
@protocol CLJIAssociative <CLJIPersistentCollection, CLJILookup>

/// Returns YES if the reciever contains an entry for a given key.  Else NO.
- (BOOL)containsKey:(id)key;

/// Returns the value associated with a given key.
- (id<CLJIMapEntry>)entryForKey:(id)aKey;

/// Creates and returns an associative object with a given value associated a given key.
- (id<CLJIAssociative>)associateKey:(id)key withValue:(id)val;

@end
