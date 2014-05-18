//
//  CLJPersistentVector.h
//  PersistentStructure
//
//  Created by Robert Widmann on 12/30/13.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJAbstractPersistentVector.h"
#import "CLJIObj.h"
#import "CLJIEditableCollection.h"
#import "CLJNode.h"
#import "CLJINode.h"
#import "CLJISeq.h"

@interface CLJPersistentVector : CLJAbstractPersistentVector <CLJIObj, CLJIEditableCollection>

- (id)initWithCount:(NSInteger)cnt shift:(NSInteger)shift root:(id<CLJINode>)root tail:(CLJArray)tail;
- (id)initWithMeta:(id<CLJIPersistentMap>)meta count:(NSInteger)cnt shift:(NSInteger)shift node:(CLJNode *)root tail:(CLJArray)tail;

+ (CLJPersistentVector *)createWithItems:(CLJArray)items;
+ (CLJPersistentVector *)createWithSeq:(id<CLJISeq>)items;
+ (CLJPersistentVector *)createWithList:(id<CLJIList>)list;

+ (CLJPersistentVector *)empty;
+ (CLJNode *)emptyNode;

- (id<CLJIPersistentVector>)assocN:(NSInteger)i value:(id)val;
- (CLJArray)arrayFor:(NSInteger)i;

- (NSInteger)shift;
- (CLJNode *)root;
- (CLJArray)tail;

@end
