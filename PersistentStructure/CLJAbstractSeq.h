//
//  _CLJSeq.h
//  PersistentStructure
//
//  Created by Robert Widmann on 12/29/13.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJISeq.h"
#import "CLJISequential.h"
#import "CLJIList.h"
#import "CLJIHashEq.h"
#import "CLJIPersistentMap.h"

@interface CLJAbstractSeq : NSObject <CLJISeq, CLJISequential, CLJIList, CLJIHashEq> {
@package
	id<CLJIPersistentMap> _meta;
}

- (instancetype)initWithMeta:(id<CLJIPersistentMap>)meta;

@end
