//
//  CLJChunkedSeq.h
//  PersistentStructure
//
//  Created by Robert Widmann on 3/26/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJAbstractSeq.h"
#import "CLJIChunkedSeq.h"

@class CLJPersistentVector;

@interface CLJChunkedSeq : CLJAbstractSeq <CLJIChunkedSeq, CLJICounted>

- (id)initWithVec:(CLJPersistentVector *)vec index:(NSInteger)i offset:(NSInteger)offset;
- (id)initWithMeta:(id<CLJIPersistentMap>)meta vec:(CLJPersistentVector *)vec node:(CLJArray)node index:(NSInteger)i offset:(NSInteger)offset;
- (id)initWithVec:(CLJPersistentVector *)vec node:(CLJArray)node index:(NSInteger)i offset:(NSInteger)offset;

@end
