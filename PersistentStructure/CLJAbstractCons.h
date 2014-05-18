//
//  _CLJCons.h
//  PersistentStructure
//
//  Created by Robert Widmann on 12/30/13.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJAbstractSeq.h"

@interface CLJAbstractCons : CLJAbstractSeq

- (id)initWithFirst:(id)first rest:(id<CLJISeq>)more;
- (id)initWithMeta:(id<CLJIPersistentMap>)meta first:(id)first rest:(id<CLJISeq>)more;
- (id)first;
- (id<CLJISeq>)next;
- (id<CLJISeq>)more;
- (NSUInteger)count;
- (CLJAbstractCons *)withMeta:(id<CLJIPersistentMap>)meta;

@end
