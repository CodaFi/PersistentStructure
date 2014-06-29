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

/// Returns a seq of the collection.
///
/// For an empty collection, the result is nil.  CLJCreateSeq(nil) returns nil.  This function works
/// on Strings, CLJArrays of objects and any type that implements NSFastEnumeration.
extern id<CLJISeq> CLJCreateSeq(id coll);

/// Returns a new sequence where x is the first element and seq is the rest.
extern id<CLJISeq> CLJCons(id x, id<CLJISeq> seq);

/// Returns the first item in the collection.
///
/// Internally, the collection will be converted to a seq.  Returns nil if the collection is empty.
extern id CLJFirst(id coll);

/// Returns the second item in the collection.
///
/// Functionally equivalent to
///
///		CLJFirst(CLJNext(coll))
///
/// Returns nil if the collection contains only one element.
extern id CLJSecond(id coll);

/// Returns the first item of the first item of a nested collection.
///
/// Functionally equivalent to
///
///		CLJFirst(CLJFirst(coll))
///
/// Returns nil if the collection is empty.
extern id CLJFFirst(id coll);

/// Returns the tail of the first item of a nested collection.
///
/// Functionally equivalent to
///
///		CLJNext(CLJFirst(coll))
///
/// Returns nil if the collection is empty.
extern id CLJNFirst(id coll);

/// Returns the tail of the tail of a nested collection.
///
/// Functionally equivalent to
///
///		CLJNext(CLJNext(coll))
///
/// Returns nil if the collection is empty.
extern id CLJNNext(id coll);

/// Returns the second item in the collection.  Alias for CLJSecond().
///
/// Functionally equivalent to
///
///		CLJFirst(CLJNext(coll))
///
/// Returns nil if the collection contains only one element.
id (* const CLJFNext)(id coll);

/// Returns the last item in a collection.
///
/// For Persistent Structure types, this function runs in linear time.
extern id CLJLast(id coll);

/// Returns a sequence of all but the last item in a collection.
///
/// For Persistent Structure types, this function runs in linear time.
extern id<CLJISeq> CLJButLast(id coll);

/// Creates and returns a new vector containing the objects in the provided collection.
extern id<CLJIPersistentVector, CLJIEditableCollection> CLJCreateVector(id coll);

/// Creates and returns a new hash map with the provided mappings.  If any keys are equal, they are
/// handled as if by repeated uses of CLJAssoc().
extern id<CLJIPersistentMap, CLJIEditableCollection> CLJCreateHashMap(id coll);

/// Creates and returns a new hash set with the provided keys.  If any keys are equal, they are
/// handled as if by repeated uses of CLJConj().
extern id<CLJIPersistentSet, CLJIEditableCollection> CLJCreateHashSet(id coll);

extern id<CLJIPersistentCollection> CLJCreateList(id restrict fst, ...);

//extern id<CLJIPersistentSet> CLJCreateSortedMap(id coll);
extern id<CLJISet> CLJCreateSet(id coll);

extern id<CLJITransientCollection> CLJCreateTransient(id<CLJIEditableCollection> coll);

/// Returns the number of items in the collection.
///
/// Also works on strings, arrays, and Objective-C collections.
extern NSUInteger CLJCount(id coll);

/// Returns the value at a given index.
///
/// If the index is out of bounds, then this function throws an exception and returns nil.
extern id CLJOverloadable CLJObjectAtIndex(id coll, NSUInteger index);

/// Returns the value at a given index, returning the provided not found value if no item is found
/// at that index.
extern id CLJOverloadable CLJObjectAtIndex(id coll, NSUInteger index, id notFound);

/// Returns YES if the provided collection implements CLJISeq.
extern BOOL CLJIsSeq(id coll);

/// Returns YES if the provided collection implements CLJIPersistentMap.
extern BOOL CLJIsMap(id coll);

/// Returns YES if the provided collection implements CLJIPersistentVector.
extern BOOL CLJIsVec(id coll);

/// Returns YES if the given key is present in the collection, otherwise NO.
///
/// For Persistent Structure types, this function operates in constant or logarithmic time.
extern BOOL CLJContains(id coll, id key);

/// Returns a seq of the items after the first.
extern id<CLJISeq> CLJNext(id coll);

/// Returns a possibly empty seq of the items after the first.
extern id<CLJISeq> CLJRest(id coll);

/// Conj[oin].  Returns a new collection with the xs 'added'.  Conjoining any item to a nil
/// collection returns a new persistent list containing only that item.
///
/// Additoin of an item may happen at different 'places' depending on the concrete type of the
/// collection.
extern id<CLJIPersistentCollection> CLJOverloadable CLJConj(id<CLJIPersistentCollection> coll, id x);
extern id<CLJIPersistentCollection> CLJOverloadable CLJConj(id<CLJIPersistentCollection> coll, id restrict xs, ...) NS_REQUIRES_NIL_TERMINATION;

/// Assoc[iate].  When applied to a map, returns a new map of the same (hashed/sorted) type that
/// contains the mapping of keys(s)to value(s).  When applied to a vector, returns a new vector that
/// contains the val at the specified index.
///
/// Note that the index must be less than or equal to the count of the vector.
extern id<CLJIPersistentCollection> CLJOverloadable CLJAssoc(id<CLJIPersistentCollection> coll, id key, id val);
extern id<CLJIPersistentCollection> CLJOverloadable CLJAssoc(id<CLJIPersistentCollection> coll, id restrict ks, id restrict vs, ...) NS_REQUIRES_NIL_TERMINATION;

/// Disj[oin]. Returns a new set of the same (hashed/sorted) type, that does not contain the given
/// keys.
extern id<CLJISet> CLJDisj(id<CLJISet> fromSet, id restrict vals, ...) NS_REQUIRES_NIL_TERMINATION;

/// Returns the metadata of the provided object or collection.  If there is no metadata associated
/// with the object, returns nil.
extern id<CLJIPersistentMap> CLJMetadata(id obj);

/// Returns an object of the same type and value as the provided object, but with the provided map
/// as its metadata.
extern id<CLJIObj> CLJWithMetadata(id<CLJIObj> obj, id<CLJIPersistentMap> m);


extern id<CLJISeq> CLJReduce1(CLJIReduceBlock reducer, id coll);
extern id<CLJISeq> CLJReduce(CLJIReduceBlock reducer, id coll, id val);

extern id<CLJISeq> CLJReduce1f(CLJIReduceFunction reducer, id coll);
extern id<CLJISeq> CLJReducef(CLJIReduceFunction reducer, id coll, id val);

#pragma mark - TBD

//extern id<CLJISeq> CLJCreateLazySeq(id restrict fst, ...);

