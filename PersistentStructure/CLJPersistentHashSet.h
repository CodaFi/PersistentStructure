//
//  CLJPersistentHashSet.h
//  PersistentStructure
//
//  Created by Robert Widmann on 3/28/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJAbstractPersistentSet.h"

@interface CLJPersistentHashSet : CLJAbstractPersistentSet <CLJIObj, CLJIEditableCollection>

+ (CLJPersistentHashSet *)createWithArray:(CLJArray)init;
+ (CLJPersistentHashSet *)createWithList:(id<CLJIList>)init;
+ (CLJPersistentHashSet *)createWithSeq:(id<CLJISeq>)items;
+ (CLJPersistentHashSet *)createWithCheckArray:(CLJArray)init;
+ (CLJPersistentHashSet *)createWithCheckList:(id<CLJIList>)init;
+ (CLJPersistentHashSet *)createWithCheckSeq:(id<CLJISeq>)items;

- (id)initWithMeta:(id<CLJIPersistentMap>)meta impl:(id<CLJIPersistentMap>)impl;

@end
