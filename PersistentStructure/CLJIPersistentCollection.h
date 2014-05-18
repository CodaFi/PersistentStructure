//
//  CLJIPersistentCollection.h
//  PersistentStructure
//
//  Created by Robert Widmann on 12/29/13.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJISeqable.h"

@protocol CLJIPersistentCollection <CLJISeqable>

- (NSUInteger)count;
- (id<CLJIPersistentCollection>)cons:(id)other;
- (id<CLJIPersistentCollection>)empty;
- (BOOL)equiv:(id)o;

@end
