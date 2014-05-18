//
//  _CLJPersistentSet.h
//  PersistentStructure
//
//  Created by Robert Widmann on 3/28/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJInterfaces.h"

@interface CLJAbstractPersistentSet : NSObject <CLJIPersistentSet, CLJICollection, CLJISet, CLJIHashEq> {
@package
	id<CLJIPersistentMap> _impl;
}

- (id)initWithImplementation:(id<CLJIPersistentMap>)impl;

@end
