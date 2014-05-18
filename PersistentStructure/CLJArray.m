//
//  CLJArray.c
//  PersistentStructure
//
//  Created by Robert Widmann on 3/25/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#include "CLJArray.h"

CLJArray CLJArrayCreate(NSUInteger size) {
	return (CLJArray){
		.array = (__strong id *)malloc(sizeof(id) * size),
		.length = size,
	};
}

NSUInteger CLJArrayCount(CLJArray array) {
	return array.length;
}

void CLJArrayFree(CLJArray array) {
	free(array.array);
	array.length = 0;
}

CLJArray CLJArrayCreateCopy(CLJArray array) {
	return (CLJArray){
		.array = array.array,
		.length = array.length,
	};
}

CLJArray CLJArrayCopy(CLJArray src, NSUInteger srcPos, CLJArray dest, NSUInteger destPos, NSUInteger length) {
	__strong id *mergeArr = (__strong id *)malloc(sizeof(id) * length);
	for (NSUInteger i = srcPos, j = 0; i < srcPos + length; i++, j++) {
		mergeArr[j] = src.array[i];
	}
	memmove((void*)&dest.array[destPos], &mergeArr, length * sizeof(id));
	return dest;
}
