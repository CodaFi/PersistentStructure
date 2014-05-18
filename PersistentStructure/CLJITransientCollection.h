//
//  CLJITransientCollection.h
//  PersistentStructure
//
//  Created by Robert Widmann on 12/30/13.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJIPersistentCollection.h"

@protocol CLJITransientCollection <NSObject>
- (id<CLJITransientCollection>)conj:(id)val;
- (id<CLJIPersistentCollection>)persistent;

@end
