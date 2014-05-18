//
//  CLJArrayNode.h
//  PersistentStructure
//
//  Created by Robert Widmann on 3/26/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJINode.h"
#import "CLJArray.h"

@interface CLJArrayNode : NSObject <CLJINode>

+ (id)createOnThread:(NSThread *)edit count:(NSInteger)count array:(CLJArray)array;

@end
