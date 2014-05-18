//
//  CLJBitmapIndexedNode.h
//  PersistentStructure
//
//  Created by Robert Widmann on 3/22/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJInterfaces.h"
#import "CLJArray.h"

@interface CLJBitmapIndexedNode : NSObject <CLJINode> {
@package
	CLJArray _array;
}

+ (CLJBitmapIndexedNode *)empty;
+ (id)createOnThread:(NSThread *)edit bitmap:(NSInteger)bitmap array:(CLJArray)array;

@end
