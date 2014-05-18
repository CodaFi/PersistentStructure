//
//  CLJSubVector.h
//  PersistentStructure
//
//  Created by Robert Widmann on 3/26/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJAbstractPersistentVector.h"
#import "CLJIObj.h"

@interface CLJSubVector : CLJAbstractPersistentVector <CLJIObj>

- (id)initWithMeta:(id<CLJIPersistentMap>)meta vector:(id<CLJIPersistentVector>)v start:(NSInteger)start end:(NSInteger)end;

@end
