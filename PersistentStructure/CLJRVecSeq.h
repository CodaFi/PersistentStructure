//
//  CLJRVecSeq.h
//  PersistentStructure
//
//  Created by Robert Widmann on 3/27/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJAbstractSeq.h"
#import "CLJIIndexedSeq.h"
#import "CLJICounted.h"
#import "CLJIPersistentVector.h"

@interface CLJRVecSeq : CLJAbstractSeq <CLJIIndexedSeq, CLJICounted>

- (id)initWithVector:(id<CLJIPersistentVector>)vector index:(NSInteger)index;
- (id)initWithMeta:(id<CLJIPersistentMap>)meta vector:(id<CLJIPersistentVector>)vector index:(NSInteger)index;

@end
