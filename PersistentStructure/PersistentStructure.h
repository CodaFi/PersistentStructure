//
//  PersistentStructure.h
//  PersistentStructure
//
//  Created by Robert Widmann on 12/29/13.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJInterfaces.h"
#import "CLJTypes.h"
#import "CLJDefines.h"

extern id<CLJISeq> CLJCons(id x, id<CLJISeq> seq);
extern id<CLJISeq> CLJCreateLazySeq(id restrict fst, ...);
extern id<CLJIPersistentCollection> CLJCreateList(id restrict fst, ...);

extern id CLJFirst(id coll);
extern id CLJSecond(id coll);
extern id CLJFirstFirst(id coll);
extern id CLJNextFirst(id coll);
extern id CLJNextNext(id coll);
id (* const CLJFirstNext)(id coll);
extern id CLJLast(id coll);
extern id<CLJISeq> CLJButLast(id coll);


extern id<CLJISeq> CLJCreateSeq(id coll);
extern id<CLJIPersistentVector, CLJIEditableCollection> CLJCreateVector(id coll);
extern id<CLJIPersistentMap, CLJIEditableCollection> CLJCreateHashMap(id coll);
extern id<CLJIPersistentSet, CLJIEditableCollection> CLJCreateHashSet(id coll);
//extern id<CLJIPersistentSet> CLJCreateSortedMap(id coll);
extern id<CLJISet> CLJCreateSet(id coll);

extern id<CLJITransientCollection> CLJCreateTransient(id<CLJIEditableCollection> coll);


extern BOOL CLJIsSeq(id coll);
extern BOOL CLJIsMap(id coll);
extern BOOL CLJIsVec(id coll);

extern BOOL CLJContains(id coll, id key);

extern id<CLJISeq> CLJReduce1(CLJIReduceBlock reducer, id<CLJISeqable> coll);
extern id<CLJISeq> CLJReduce(CLJIReduceBlock reducer, id<CLJISeqable> coll, id val);

extern id<CLJISeq> CLJReduce1f(CLJIReduceFunction reducer, id<CLJISeqable> coll);
extern id<CLJISeq> CLJReducef(CLJIReduceFunction reducer, id<CLJISeqable> coll, id val);

extern id<CLJISeq> CLJNext(id coll);
extern id<CLJISeq> CLJRest(id coll);

extern id<CLJIPersistentCollection> CLJOverloadable CLJConj(id<CLJIPersistentCollection> coll, id x);
extern id<CLJIPersistentCollection> CLJOverloadable CLJConj(id<CLJIPersistentCollection> coll, id restrict xs, ...) NS_REQUIRES_NIL_TERMINATION;

extern id<CLJIPersistentCollection> CLJOverloadable CLJAssoc(id<CLJIPersistentCollection> coll, id key, id val);
extern id<CLJIPersistentCollection> CLJOverloadable CLJAssoc(id<CLJIPersistentCollection> coll, id restrict ks, id restrict vs, ...) NS_REQUIRES_NIL_TERMINATION;

extern id<CLJISet> CLJOverloadable CLJDisjoin(id<CLJISet> fromSet);
extern id<CLJISet> CLJOverloadable CLJDisjoin(id<CLJISet> fromSet, id restrict vals, ...);
