//
//  CLJIList.h
//  PersistentStructure
//
//  Created by Robert Widmann on 12/29/13.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

@protocol CLJICollection;

#import "CLJArray.h"
#import "CLJICollection.h"

@protocol CLJIList <CLJICollection>

- (BOOL)containsObject:(id)o;
- (BOOL)isEqual:(id)object;
- (id)get:(NSInteger)index;
- (NSInteger)indexOf:(id)o;
- (BOOL)isEmpty;
- (NSEnumerator *)objectEnumerator;
- (NSInteger)lastIndexOf:(id)o;
- (id)set:(NSInteger)index element:(id)element;
- (NSUInteger)count;
- (id<CLJIList>)subListFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;
- (CLJArray)toArray;

@end
