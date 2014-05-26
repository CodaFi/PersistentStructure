//
//  CLJISeqable.h
//  PersistentStructure
//
//  Created by Robert Widmann on 12/29/13.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJISeq.h"

/// The CLJISeqable protocol declares a method for providing a Seq of an object.  How the Seq is
/// produced depends varies from class to class, but for Persistent Structure types the Seq can
/// be generated in constant or logarithmic time, or even lazily.
///
/// Internally, most objects can be converted to Seqs by the framework if necessary, however doing
/// so occurs in linear or exponential time, so it is recommended that the reciever become Seqable
/// for efficiency's sake.
@protocol CLJISeqable <NSObject>

/// Returns a new instance of a Seq containing the reciever's values.
- (id<CLJISeq>)seq;

@end
