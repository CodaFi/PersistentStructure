//
//  CLJArray.h
//  PersistentStructure
//
//  Created by Robert Widmann on 3/25/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#ifndef PERSISTENT_STRUCTURE_CLJARRAY_H
#define PERSISTENT_STRUCTURE_CLJARRAY_H

typedef struct {
	__strong id *array;
	NSUInteger length;
} CLJArray;

extern CLJArray CLJArrayCreate(NSUInteger size);
extern void CLJArrayFree(CLJArray array);

extern NSUInteger CLJArrayCount(CLJArray array);
extern CLJArray CLJArrayCreateCopy(CLJArray array);
extern CLJArray CLJArrayCopy(CLJArray src, NSUInteger srcPos, CLJArray dest, NSUInteger destPos, NSUInteger length);

#endif
