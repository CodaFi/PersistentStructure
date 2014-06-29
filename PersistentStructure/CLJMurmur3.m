//
//  CLJMurmur3.m
//  PersistentStructure
//
//  Created by IDA WIDMANN on 6/24/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//

#import "CLJMurmur3.h"
#import "CLJUtils.h"
#import "murmur3.h"
#include <stdlib.h>
#include <stdio.h>

@implementation CLJMurmur3

+ (NSUInteger)hashOrdered:(id<NSFastEnumeration>)xs {
	NSUInteger n = 0;
	NSUInteger hash = 1;
	
	for (id x in xs) {
		hash = 31 * hash + [CLJUtils hasheq:x];
		++n;
	}
	return [CLJMurmur3 mixCollHash:hash count:n];
}

+ (NSUInteger)hashUnordered:(id<NSFastEnumeration>)xs {
	NSUInteger hash = 0;
	NSUInteger n = 0;
	for (id x in xs) {
		hash += [CLJUtils hasheq:x];
		++n;
	}
	
	return [CLJMurmur3 mixCollHash:hash count:n];
}

+ (NSUInteger)mixCollHash:(NSUInteger)hash count:(NSUInteger)count {
	NSUInteger outhash;
	char buffer[65];
	sprintf(buffer, "%lu", (unsigned long)hash);
	MurmurHash3_x86_128(buffer, (int)strlen(buffer), 0, &outhash);
	return outhash;
}

@end
