//
//  CLJIComparable.h
//  PersistentStructure
//
//  Created by Robert Widmann on 12/30/13.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

@protocol CLJIComparable <NSObject>
- (NSComparisonResult)compareTo:(id)other;
@end
