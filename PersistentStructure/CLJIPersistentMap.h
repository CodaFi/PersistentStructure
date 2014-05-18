//
//  CLJIPersistentMap.h
//  PersistentStructure
//
//  Created by Robert Widmann on 12/29/13.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJIAssociative.h"
#import "CLJICounted.h"

@protocol CLJIPersistentMap <NSFastEnumeration, CLJIAssociative, CLJICounted>

- (id<CLJIPersistentMap>)associateKey:(id)key value:(id)val;
- (id<CLJIPersistentMap>)assocEx:(id)key value:(id)val;
- (id<CLJIPersistentMap>)without:(id)key;

@end
