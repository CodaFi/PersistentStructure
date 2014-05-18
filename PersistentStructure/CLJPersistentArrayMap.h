//
//  CLJPersistentArrayMap.h
//  PersistentStructure
//
//  Created by Robert Widmann on 3/27/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJAbstractPersistentMap.h"
#import "CLJInterfaces.h"

@interface CLJPersistentArrayMap : CLJAbstractPersistentMap <CLJIObj, CLJIEditableCollection>

- (id)initWithArray:(CLJArray)init;

@end
