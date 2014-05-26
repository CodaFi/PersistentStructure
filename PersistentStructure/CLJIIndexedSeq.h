//
//  CLJIIndexedSeq.h
//  PersistentStructure
//
//  Created by Robert Widmann on 12/30/13.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJISeq.h"
#import "CLJISequential.h"
#import "CLJICounted.h"

/// The CLJIIndexedSeq protocol declares the method required to get the starting or ending index
/// from a Seq.
@protocol CLJIIndexedSeq <CLJISeq, CLJISequential, CLJICounted>

/// Returns the starting or ending index for the reciever.
- (NSInteger)index;

@end
