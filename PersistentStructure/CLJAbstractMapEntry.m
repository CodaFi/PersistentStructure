//
//  _CLJMapEntry.m
//  PersistentStructure
//
//  Created by Robert Widmann on 12/30/13.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJAbstractMapEntry.h"
#import "CLJInterfaces.h"
#import "CLJLazilyPersistentVector.h"

@implementation CLJAbstractMapEntry

- (id)objectAtIndex:(NSInteger)i {
	if (i == 0) {
		return self.key;
	} else if (i == 1) {
		return self.val;
	} else {
		[NSException raise:NSRangeException format:@"Range or index out of bounds"];
	}
	return nil;
}

- (id<CLJIPersistentVector>)asVector {
	__strong id arr[2] = { self.key, self.val };
	return (id<CLJIPersistentVector>)[CLJLazilyPersistentVector createOwning:(CLJArray){
		.array = arr,
		.length = 2,
	}];
}

- (id<CLJIPersistentVector>)assocN:(NSInteger)i value:(id)val {
	return [(id<CLJIPersistentVector>)self.asVector assocN:i value:val];
}

- (NSUInteger)count {
	return 2;
}

- (id<CLJISeq>)seq {
	return self.asVector.seq;
}

-(id<CLJIPersistentVector>)cons:(id)o {
	return (id<CLJIPersistentVector>)[self.asVector cons:o];
}

- (id<CLJIPersistentCollection>)empty {
	return nil;
}

- (id<CLJIPersistentStack>)pop {
	__strong id arr[1] = { self.key };
	return (id<CLJIPersistentStack>)[CLJLazilyPersistentVector createOwning:(CLJArray){
		.array = arr,
		.length = 1,
	}];
}

#pragma mark - Abtract

- (id)setValue:(id)value {
	return nil;
}

- (id)key {
	return nil;
}

- (id)val {
	return nil;
}

@end
