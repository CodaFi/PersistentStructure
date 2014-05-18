//
//  CLJPersistentHashMap.h
//  PersistentStructure
//
//  Created by Robert Widmann on 12/30/13.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJAbstractPersistentMap.h"
#import "CLJInterfaces.h"

@protocol CLJINode;
@class CLJTransientHashMap;

@interface CLJPersistentHashMap : CLJAbstractPersistentMap <CLJIEditableCollection>

+ (id<CLJIPersistentMap>)create:(id<CLJIMap>)other;
+ (CLJPersistentHashMap *)createList:(id)init, ... NS_REQUIRES_NIL_TERMINATION;
+ (CLJPersistentHashMap *)createV:(va_list)init;
+ (CLJPersistentHashMap *)createWithCheck:(id)init, ... NS_REQUIRES_NIL_TERMINATION;
+ (CLJPersistentHashMap *)createWithSeq:(id<CLJISeq>)items;
+ (CLJPersistentHashMap *)createWithCheckSeq:(id<CLJISeq>)items;
+ (CLJPersistentHashMap *)createWithMeta:(id<CLJIPersistentMap>)meta values:(id)init, ... NS_REQUIRES_NIL_TERMINATION;
+ (CLJPersistentHashMap *)createWithMeta:(id<CLJIPersistentMap>)meta array:(CLJArray)array;

- (id)initWithCount:(NSUInteger)count root:(id<CLJINode>)root hasNull:(BOOL)hasNull nullValue:(id)nullValue;
- (id)initWithMeta:(id<CLJIPersistentMap>)meta count:(NSUInteger)count root:(id<CLJINode>)root hasNull:(BOOL)hasNull nullValue:(id)nullValue;

- (id<CLJINode>)root;
- (BOOL)hasNull;
- (id)nullValue;

- (CLJTransientHashMap *)asTransient;
+ (id<CLJIPersistentCollection>)empty;

@end
