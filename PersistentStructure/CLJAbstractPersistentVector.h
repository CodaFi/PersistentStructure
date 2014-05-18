//
//  _CLJPersistentVector.h
//  PersistentStructure
//
//  Created by Robert Widmann on 12/30/13.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJIPersistentVector.h"
#import "CLJIList.h"
#import "CLJIComparable.h"
#import "CLJIHashEq.h"

@interface CLJAbstractPersistentVector : NSObject <CLJIPersistentVector, NSFastEnumeration, CLJIList, /*RandomAccess,*/ CLJIComparable, CLJIHashEq>

@end
