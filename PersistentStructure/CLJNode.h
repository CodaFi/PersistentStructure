//
//  CLJNode.h
//  PersistentStructure
//
//  Created by Robert Widmann on 3/26/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJArray.h"
#import "CLJINode.h"

@interface CLJNode : NSObject

- (id)initWithThread:(NSThread *)edit;
- (id)initWithThread:(NSThread *)edit array:(CLJArray)array;

@property (nonatomic, strong, readonly) NSThread *edit;
@property (nonatomic, readonly) CLJArray array;

@end
