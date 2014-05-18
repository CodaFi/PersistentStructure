//
//  CLJSeq.h
//  PersistentStructure
//
//  Created by Robert Widmann on 3/26/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJAbstractSeq.h"
#import "CLJArray.h"

@interface CLJSeq : CLJAbstractSeq

+ (id<CLJISeq>)create:(CLJArray)nodes;

@end
