//
//  CLJPersistentTreeMap.h
//  PersistentStructure
//
//  Created by Robert Widmann on 5/25/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//

#import "CLJAbstractPersistentMap.h"
#import "CLJInterfaces.h"

@class CLJTreeNode;

@interface CLJPersistentTreeMap : CLJAbstractPersistentMap <CLJIObj, CLJIReversible, CLJISorted>

- (id)initWithMeta:(id<CLJIPersistentMap>)meta comparator:(CLJComparatorBlock)comp;
- (id)initWithMeta:(id<CLJIPersistentMap>)meta comparator:(CLJComparatorBlock)comp tree:(CLJTreeNode *)tree count:(NSInteger)count;
- (id)initWithComparator:(CLJComparatorBlock)comp tree:(CLJTreeNode *)tree count:(NSInteger)count meta:(id<CLJIPersistentMap>)meta;

+ (CLJPersistentTreeMap *)empty;

@end
