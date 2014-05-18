//
//  CLJHashCollisionNode.h
//  PersistentStructure
//
//  Created by Robert Widmann on 3/26/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJInterfaces.h"
#import "CLJArray.h"

@interface CLJHashCollisionNode : NSObject <CLJINode>

- (id)initWithThread:(NSThread *)edit hash:(NSInteger)hash count:(NSInteger)count array:(CLJArray)array;

@end
