//
//  CLJITransientMap.h
//  PersistentStructure
//
//  Created by Robert Widmann on 12/30/13.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJICounted.h"
#import "CLJITransientAssociative.h"
#import "CLJITransientMap.h"
#import "CLJIPersistentMap.h"

@protocol CLJITransientMap <CLJITransientAssociative, CLJICounted>

- (id<CLJITransientMap>)associateKey:(id)key value:(id)val;
- (id<CLJITransientMap>)without:(id)key;
- (id<CLJIPersistentMap>)persistent;

@end
