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

- (id)objectForKey:(id)key;
- (id)setObject:(id)val forKey:(id)key;;

- (BOOL)containsKey:(id)key;
- (BOOL)containsValue:(id)value;
- (id<CLJISet> /*id<CLJIMapEntry>*/)allEntries;
- (BOOL)isEmpty;
- (id<CLJISet>)allKeys;

- (NSUInteger)count;
- (id<CLJICollection>)values;

@end
