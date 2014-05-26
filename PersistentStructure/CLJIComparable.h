//
//  CLJIComparable.h
//  PersistentStructure
//
//  Created by Robert Widmann on 12/30/13.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

/// The CLJIComparable protocol lists the only method required of an object that admits ordering.
@protocol CLJIComparable <NSObject>

/// Compares the reciever to another and returns an order.
///
/// If the reciever is smaller than the other object, this method returns NSOrderedAscending.  If
/// the reciever is greater than the other object, this method returns NSOrderedDescending.  Else,
/// this method returns NSOrderedSame.
- (NSComparisonResult)compareTo:(id)other;

@end
