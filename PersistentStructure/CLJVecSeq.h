//
//  CLJVecSeq.h
//  PersistentStructure
//
//  Created by Robert Widmann on 3/26/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJAbstractSeq.h"
#import "CLJIIndexedSeq.h"
#import "CLJIReduce.h"
#import "CLJIPersistentVector.h"

@interface CLJVecSeq : CLJAbstractSeq <CLJIIndexedSeq, CLJIReducible>

- (id)initWithVector:(id<CLJIPersistentVector>)v index:(NSInteger)i;
- (id)initWithMeta:(id<CLJIPersistentMap>)meta vector:(id<CLJIPersistentVector>)v index:(NSInteger)i;

@end
