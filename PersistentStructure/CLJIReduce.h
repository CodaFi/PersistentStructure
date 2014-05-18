//
//  CLJIReduce.h
//  PersistentStructure
//
//  Created by Robert Widmann on 12/30/13.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#include "CLJTypes.h"

@protocol CLJIReduce <NSObject>
- (id)reduce:(CLJIReduceBlock)f;
- (id)reduce:(CLJIReduceBlock)f start:(id)start;

@end
