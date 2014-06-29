//
//  CLJObj.h
//  PersistentStructure
//
//  Created by IDA WIDMANN on 6/24/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLJInterfaces.h"

@interface CLJObj : NSObject <CLJIObj, CLJIMeta>

- (id)initWithMeta:(id<CLJIPersistentMap>)meta;

@end
