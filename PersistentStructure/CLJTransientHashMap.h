//
//  CLJTransientHashMap.h
//  PersistentStructure
//
//  Created by Robert Widmann on 3/22/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJAbstractTransientMap.h"

@class CLJPersistentHashMap;

@interface CLJTransientHashMap : CLJAbstractTransientMap

+ (instancetype)create:(CLJPersistentHashMap *)m;

@end
