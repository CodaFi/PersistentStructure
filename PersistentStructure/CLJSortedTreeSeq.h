//
//  CLJSortedTreeSeq.h
//  PersistentStructure
//
//  Created by Robert Widmann on 6/1/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//

#import "CLJAbstractSeq.h"

@class CLJTreeNode;

@interface CLJSortedTreeSeq : CLJAbstractSeq

+ (CLJSortedTreeSeq *)createWithRoot:(CLJTreeNode *)t ascending:(BOOL)asc count:(NSInteger)cnt;

- (id)initWithStack:(id<CLJISeq>)stack ascending:(BOOL)asc;
- (id)initWithStack:(id<CLJISeq>)stack ascending:(BOOL)asc count:(NSInteger)count;
- (instancetype)initWithMeta:(id<CLJIPersistentMap>)meta stack:(id<CLJISeq>)stack ascending:(BOOL)asc count:(NSInteger)count;

@end
