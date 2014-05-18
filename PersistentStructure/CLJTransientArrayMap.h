//
//  CLJTransientArrayMap.h
//  PersistentStructure
//
//  Created by Robert Widmann on 3/28/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJAbstractTransientMap.h"
#import "CLJInterfaces.h"

@interface CLJTransientArrayMap : CLJAbstractTransientMap

- (id)initWithArray:(CLJArray)array;

@end
