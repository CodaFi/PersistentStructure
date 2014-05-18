//
//  CLJTransientVector.h
//  PersistentStructure
//
//  Created by Robert Widmann on 3/26/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJInterfaces.h"

@class CLJPersistentVector;

@interface CLJTransientVector : NSObject <CLJITransientVector, CLJICounted>

- (id)initWithPersistentVector:(CLJPersistentVector *)v;

@end
