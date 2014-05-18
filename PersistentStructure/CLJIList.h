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

@protocol CLJIList <CLJICollection>

- (BOOL)containsObject:(id)o;
- (BOOL)containsAll:(id<CLJICollection>)c;
- (BOOL)isEqual:(id)object;
- (id)get:(NSInteger)index;
- (NSInteger)indexOf:(id)o;
- (BOOL)isEmpty;
- (NSEnumerator *)objectEnumerator;
- (NSInteger)lastIndexOf:(id)o;
//ListIterator	listIterator()
//ListIterator	listIterator(NSInteger index)
- (id)set:(NSInteger)index element:(id)element;
- (NSUInteger)count;
- (id<CLJIList>)subListFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;
- (CLJArray)toArray;

@end
