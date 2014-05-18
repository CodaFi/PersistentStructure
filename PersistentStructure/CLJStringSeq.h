//
//  CLJStringSeq.h
//  PersistentStructure
//
//  Created by Robert Widmann on 3/27/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJAbstractSeq.h"
#import "CLJIIndexedSeq.h"

@interface CLJStringSeq : CLJAbstractSeq <CLJIIndexedSeq>

- (id)initWithString:(NSString *)s;
- (id)initWithMeta:(id<CLJIPersistentMap>)meta string:(NSString *)string index:(NSInteger)index;

@end
