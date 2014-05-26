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

/// The CLJIChunkedSeq protocol describes the methods necessary for an object to act like both a
/// Chunk and a Seq.  Chunked Sequences can act like enumerable windows into the values of a
/// collection.
@protocol CLJIChunkedSeq <CLJISeq, CLJISequential>

- (id<CLJIChunk>)chunkedFirst;
- (id<CLJISeq>)chunkedNext;
- (id<CLJISeq>)chunkedMore;

@end
