//
//  CLJQueueSeq.h
//  PersistentStructure
//
//  Created by IDA WIDMANN on 6/24/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//

#import "CLJAbstractSeq.h"

@interface CLJQueueSeq : CLJAbstractSeq

- (id)initWithFirst:(id<CLJISeq>)f rev:(id<CLJISeq>)rseq;
- (instancetype)initWithMeta:(id<CLJIPersistentMap>)meta first:(id<CLJISeq>)f rev:(id<CLJISeq>)rseq;

@end
