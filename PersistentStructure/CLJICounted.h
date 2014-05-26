//
//  CLJICounted.h
//  PersistentStructure
//
//  Created by Robert Widmann on 12/29/13.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import <Foundation/Foundation.h>

/// The CLJICounted protocol declares the only method required of an object from which a count of
/// values can be requested.
///
/// Generally, objects implementing this protocol return their counts in constant or logarithmic
/// time.  However, some objects used for enumeration (such as certain types of Lazy Sequences) must
/// evaluate themselves in linear time to return a count.
@protocol CLJICounted <NSObject>

/// Returns the number of values currently in the collection.
- (NSUInteger)count;

@end
