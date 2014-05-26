//
//  CLJSeq.h
//  PersistentStructure
//
//  Created by Robert Widmann on 12/29/13.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

@protocol CLJIPersistentCollection;

/// The CLJISeq protocol describes the methods necessary for an object to act like a Seq.  Seqs are
/// immmutable sequences of values that the framework uses internally for all enumeration work
/// because their creation usually occurs in constant or logarithmic time.
@protocol CLJISeq <CLJIPersistentCollection>

/// THe first object in the sequence, or nil is the sequence is empty.
- (id)first;

/// All but the first object in the sequence, or nil if the sequence is empty.
- (id<CLJISeq>)next;

/// All but the first object in the sequence, or an empty sequence if the reciever has no values.
- (id<CLJISeq>)more;

/// Returns a new sequence with `object` as the first value and the reciever as the next value.
- (id<CLJISeq>)cons:(id)object;

@end
