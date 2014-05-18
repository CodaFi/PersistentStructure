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

@protocol CLJIIndexedSeq <CLJISeq, CLJISequential, CLJICounted>

- (NSInteger)index;

@end
