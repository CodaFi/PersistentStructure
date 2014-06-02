//
//  CLJPersistentTreeMap.h
//  PersistentStructure
//
//  Created by Robert Widmann on 5/25/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//

#import "CLJAbstractPersistentMap.h"
#import "CLJInterfaces.h"

@interface CLJPersistentTreeMap : CLJAbstractPersistentMap <CLJIObj, CLJReversible, CLJISorted>

@end
