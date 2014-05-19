//
//  CLJDataStructuresSpec.m
//  PersistentStructure
//
//  Created by Robert Widmann on 4/10/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

CLJTestBegin(CLJDataStructures)

/// (defn diff [s1 s2]
///		(seq (reduce disj (set s1) (set s2))))

- (id<CLJISeq>)diff:(id<CLJISeq>)seq1 and:(id<CLJISeq>)seq2 {
	return CLJCreateSeq(CLJReduce(^id(id<CLJISet> a, id b) {
		return CLJDisjoin(a, b);
	}, CLJCreateSet(seq1), CLJCreateSet(seq2)));
}

- (BOOL)isTransient:(id)x {
	return [x conformsToProtocol:@protocol(CLJITransientCollection)];
}

CLJTestEnd
