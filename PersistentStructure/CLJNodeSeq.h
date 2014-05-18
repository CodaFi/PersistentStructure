//
//  CLJNodeSeq.h
//  PersistentStructure
//
//  Created by Robert Widmann on 3/25/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJAbstractSeq.h"
#import "CLJArray.h"
#import "CLJTypes.h"

@interface CLJNodeSeq : CLJAbstractSeq

- (id)initWithArray:(CLJArray)array;
- (id)initWithArray:(CLJArray)array index:(NSInteger)index;
- (id)initWithArray:(CLJArray)array index:(NSInteger)index sequence:(id<CLJISeq>)seq;
- (id)initWithMeta:(id<CLJIPersistentMap>)meta array:(CLJArray)array index:(NSInteger)index sequence:(id<CLJISeq>)seq;

+ (id)kvreducearray:(CLJArray)array reducer:(CLJIKeyValueReduceBlock)f init:(id)init;

@end
