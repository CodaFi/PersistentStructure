//
//  CLJISorted.h
//  PersistentStructure
//
//  Created by Robert Widmann on 5/25/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//

#import "CLJTypes.h"

@protocol CLJISorted <NSObject>

- (CLJComparatorBlock)comparator;
- (id)entryKey:(id)entry;
- (id<CLJISeq>)seq:(BOOL)ascending;
- (id<CLJISeq>)seqFrom:(id)key ascending:(BOOL)ascending;

@end
