//
//  CLJArrayChunk.h
//  PersistentStructure
//
//  Created by Robert Widmann on 3/26/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJIChunk.h"
#import "CLJArray.h"

@interface CLJArrayChunk : NSObject <CLJIChunk>

- (id)initWithArray:(CLJArray)array;
- (id)initWithArray:(CLJArray)array offset:(NSInteger)offset;
- (id)initWithArray:(CLJArray)array offset:(NSInteger)offset end:(NSInteger)end;

@end
