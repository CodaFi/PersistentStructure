//
//  CLJSeqIterator.h
//  PersistentStructure
//
//  Created by Robert Widmann on 3/26/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJInterfaces.h"

@interface CLJSeqIterator : NSEnumerator

- (id)initWithSeq:(id<CLJISeq>)seq;

@end
