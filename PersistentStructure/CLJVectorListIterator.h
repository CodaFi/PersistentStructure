//
//  CLJVectorListIterator.h
//  PersistentStructure
//
//  Created by Robert Widmann on 5/18/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//

#import "CLJInterfaces.h"

@interface CLJVectorListIterator : NSEnumerator

- (id)initWithVector:(id<CLJIPersistentVector>)vec index:(NSUInteger)index;

@end
