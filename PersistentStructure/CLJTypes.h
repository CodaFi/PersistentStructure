//
//  CLJTypes.h
//  PersistentStructure
//
//  Created by Robert Widmann on 12/30/13.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#ifndef PERSISTENT_STRUCTURE_CLJTYPES_H
#define PERSISTENT_STRUCTURE_CLJTYPES_H

// Reduce (foldl1) :: (a -> b -> b) -> [a] -> b
typedef id(^CLJIReduceBlock)(id a, id b);

// Reduce (foldl1) :: (a -> b -> b) -> [a] -> b
typedef id(*CLJIReduceFunction)(id a, id b);

// Key-Value Reduce :: 
typedef id(^CLJIKeyValueReduceBlock)(id init, id a, id b);
#endif
