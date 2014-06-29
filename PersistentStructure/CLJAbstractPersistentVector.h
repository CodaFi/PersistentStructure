//
//  _CLJPersistentVector.h
//  PersistentStructure
//
//  Created by Robert Widmann on 12/30/13.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJInterfaces.h"

@interface CLJAbstractPersistentVector : NSObject <CLJIPersistentVector, NSFastEnumeration, CLJIList, CLJIRandom, CLJIComparable, CLJIHashEq>

@end
