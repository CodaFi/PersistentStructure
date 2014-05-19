//
//  CLJPersistentVectorIterator.h
//  PersistentStructure
//
//  Created by Robert Widmann on 5/18/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//

#import "CLJInterfaces.h"
#import "CLJPersistentVector.h"

@interface CLJPersistentVectorIterator : NSEnumerator

- (id)initWithVector:(CLJPersistentVector *)vec start:(NSUInteger)index;

@end
