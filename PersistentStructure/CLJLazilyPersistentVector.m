//
//  CLJLazilyPersistentVector.m
//  PersistentStructure
//
//  Created by Robert Widmann on 3/22/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJLazilyPersistentVector.h"
#import "CLJPersistentVector.h"
#import "CLJICollection.h"
#import "CLJISeq.h"
#import "CLJUtils.h"

@implementation CLJLazilyPersistentVector

+ (instancetype)createOwning:(CLJArray)items {
	if (items.length == 0) {
		return (CLJLazilyPersistentVector *)CLJPersistentVector.empty;
	} else if (items.length <= 32) {
		return (CLJLazilyPersistentVector *)[[CLJPersistentVector alloc] initWithCount:items.length shift:5 root:(id<CLJINode>)CLJPersistentVector.emptyNode tail:items];
	}
	return (CLJLazilyPersistentVector *)[CLJPersistentVector createWithItems:items];
}

+ (instancetype)create:(id<CLJICollection>)coll {
	if (![coll conformsToProtocol:@protocol(CLJISeq)] && coll.count <= 32) {
		return [CLJLazilyPersistentVector createOwning:[coll toArray]];
	}
	return (CLJLazilyPersistentVector *)[CLJPersistentVector createWithSeq:[CLJUtils seq:coll]];
}

@end
