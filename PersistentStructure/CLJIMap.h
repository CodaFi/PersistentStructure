//
//  CLJIMap.h
//  PersistentStructure
//
//  Created by Robert Widmann on 12/29/13.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJICollection.h"
#import "CLJISet.h"

@protocol CLJIMap <NSObject>

- (BOOL)containsKey:(id)key;
- (BOOL)containsValue:(id)value;
- (id<CLJISet> /*id<CLJIMapEntry>*/)entrySet;
- (BOOL)isEqual:(id)o;
- (id)get:(id)key;
- (BOOL)isEmpty;
- (id<CLJISet>)keySet;
- (id)put:(id) key with:(id)value;
- (void)putAll:(id<CLJIMap>)m;
- (NSUInteger)count;
- (id<CLJICollection>)values;

@end
