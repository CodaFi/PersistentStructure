//
//  _CLJTransientSet.h
//  PersistentStructure
//
//  Created by Robert Widmann on 3/28/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJInterfaces.h"

@interface CLJAbstractTransientSet : NSObject <CLJITransientSet> {
@package
	id<CLJITransientMap> _impl;
}

- (id)initWithImplementation:(id<CLJITransientMap>)impl;

@end
