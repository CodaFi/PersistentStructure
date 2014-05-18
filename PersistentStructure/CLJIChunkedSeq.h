//
//  CLJIChunkedSeq.h
//  PersistentStructure
//
//  Created by Robert Widmann on 3/26/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJISeq.h"
#import "CLJISequential.h"
#import "CLJIChunk.h"

@protocol CLJIChunkedSeq <CLJISeq, CLJISequential>

- (id<CLJIChunk>)chunkedFirst;
- (id<CLJISeq>)chunkedNext;
- (id<CLJISeq>)chunkedMore;

@end
