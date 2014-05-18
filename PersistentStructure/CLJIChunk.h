//
//  CLJIChunk.h
//  PersistentStructure
//
//  Created by Robert Widmann on 3/26/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJIIndexed.h"
#include "CLJTypes.h"

@protocol CLJIChunk <CLJIIndexed>

/// Returns a new chunk with the same objects as the reciever except the first.
- (id<CLJIChunk>)tail;

/// Applies a reducer function to all the elements of the chunk in sequence.
- (id)reduce:(CLJIReduceBlock)f start:(id)start;

@end
