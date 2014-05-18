//
//  CLJITransientVector.h
//  PersistentStructure
//
//  Created by Robert Widmann on 12/30/13.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJITransientAssociative.h"
#import "CLJIIndexed.h"

@protocol CLJITransientVector <CLJITransientAssociative, CLJIIndexed>

- (id<CLJITransientVector>)assocN:(NSInteger)i value:(id)val;
- (id<CLJITransientVector>)pop;

@end
