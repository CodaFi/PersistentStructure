//
//  CLJIPersistentVector.h
//  PersistentStructure
//
//  Created by Robert Widmann on 12/29/13.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJIAssociative.h"
#import "CLJISequential.h"
#import "CLJIPersistentStack.h"
#import "CLJIReversible.h"
#import "CLJIIndexed.h"

@protocol CLJIPersistentVector <CLJIAssociative, CLJISequential, CLJIPersistentStack, CLJIReversible, CLJIIndexed>

- (id<CLJIPersistentVector>)assocN:(NSInteger)i value:(id)val;
- (id<CLJIPersistentVector>)cons:(id)o;

@end
