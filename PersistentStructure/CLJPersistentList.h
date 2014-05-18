//
//  CLJIPersistentList.h
//  PersistentStructure
//
//  Created by Robert Widmann on 12/30/13.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJAbstractSeq.h"
#import "CLJIPersistentList.h"
#import "CLJIReduce.h"
#import "CLJIList.h"
#import "CLJICounted.h"

@interface CLJPersistentList : CLJAbstractSeq <CLJIPersistentList, CLJIReduce, CLJIList, CLJICounted>

+ (id<CLJIPersistentCollection>)empty;
- (id)initWithFirstObject:(id)first;

@end
