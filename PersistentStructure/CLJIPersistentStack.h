//
//  CLJIPersistentStack.h
//  PersistentStructure
//
//  Created by Robert Widmann on 12/29/13.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import <Foundation/Foundation.h>

#import "CLJIPersistentCollection.h"

@protocol CLJIPersistentStack <CLJIPersistentCollection>
- (id)peek;
- (id<CLJIPersistentStack>)pop;
@end
