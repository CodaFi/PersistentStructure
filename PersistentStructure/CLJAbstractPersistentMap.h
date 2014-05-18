//
//  _CLJPersistentMap.h
//  PersistentStructure
//
//  Created by Robert Widmann on 12/29/13.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJIPersistentCollection.h"
#import "CLJIPersistentMap.h"
#import "CLJIMap.h"
#import "CLJIMapEquivalence.h"
#import "CLJIHashEq.h"

@interface CLJAbstractPersistentMap : NSObject <CLJIPersistentMap, CLJIMap, NSFastEnumeration, CLJIMapEquivalence, CLJIHashEq>

@end
