//
//  CLJKeySeq.h
//  PersistentStructure
//
//  Created by Robert Widmann on 3/28/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJAbstractSeq.h"

@interface CLJKeySeq : CLJAbstractSeq

+ (CLJKeySeq *)create:(id<CLJISeq>)seq;
- (instancetype)initWithSeq:(id<CLJISeq>)seq;
- (instancetype)initWithMeta:(id<CLJIPersistentMap>)meta seq:(id<CLJISeq>)seq;
- (id)first;
- (id<CLJISeq>)next;
- (CLJKeySeq *)withMeta:(id<CLJIPersistentMap>)meta;

@end
