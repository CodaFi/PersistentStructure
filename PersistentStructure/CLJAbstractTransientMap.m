//
//  _CLJTransientMap.m
//  PersistentStructure
//
//  Created by Robert Widmann on 12/31/13.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJAbstractTransientMap.h"
#import "CLJInterfaces.h"
#import "CLJMapEntry.h"
#import "CLJUtils.h"

@implementation CLJAbstractTransientMap

- (void)ensureEditable {}
- (id<CLJITransientMap>)doassociateKey:(id)key :val { return nil; }
- (id<CLJITransientMap>)doWithout:(id)key { return nil; }
- (id)doobjectForKey:(id)key :notFound { return nil; }
- (NSInteger)doCount { return 0; }
- (id<CLJIPersistentMap>)doPersistent { return nil; }

- (id<CLJITransientCollection>)conj:(id)o {
	[self ensureEditable];
	if ([o isKindOfClass:CLJMapEntry.class]) {
		CLJMapEntry *e = (CLJMapEntry *)o;
		
		return [self associateKey:e.key value:e.val];
	} else if ([o conformsToProtocol:@protocol(CLJIPersistentVector)]) {
		id<CLJIPersistentVector> v = (id<CLJIPersistentVector>) o;
		if (v.count != 2) {
			[NSException raise:NSInvalidArgumentException format:@"Vector arg to map conj: must be a pair"];
		}
		return [self associateKey:[v objectAtIndex:0] value:[v objectAtIndex:1]];
	}
	
	id<CLJITransientMap> ret = self;
	for (id<CLJISeq> es = [CLJUtils seq:o]; es != nil; es = es.next) {
		CLJMapEntry *e = (CLJMapEntry *)es.first;
		ret = [ret associateKey:e.key value:e.val];
	}
	return ret;
}

- (id)objectForKey:(id)key{
	return [self objectForKey:key default:nil];
}

- (id<CLJITransientMap>)associateKey:(id)key value:(id)val {
	[self ensureEditable];
	return [self doassociateKey:key :val];
}

- (id<CLJITransientMap>)without:(id)key {
	[self ensureEditable];
	return [self doWithout:key];
}

- (id<CLJIPersistentMap>)persistent {
	[self ensureEditable];
	return [self doPersistent];
}

- (id)objectForKey:(id)key default:(id)notFound {
	[self ensureEditable];
	return [self doobjectForKey:key :notFound];
}

- (NSUInteger)count {
	[self ensureEditable];
	return [self doCount];
}

@end
