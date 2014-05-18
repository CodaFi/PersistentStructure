//
//  CLJLazilyPersistentVector.h
//  PersistentStructure
//
//  Created by Robert Widmann on 3/22/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import <Foundation/Foundation.h>
#import "CLJInterfaces.h"

@interface CLJLazilyPersistentVector : NSObject

+ (instancetype)create:(id<CLJICollection>)col;
+ (instancetype)createOwning:(CLJArray)items;

@end
