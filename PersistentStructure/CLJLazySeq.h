//
//  CLJLazySeq.h
//  PersistentStructure
//
//  Created by Robert Widmann on 12/29/13.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJISeq.h"
#import "CLJISequential.h"
#import "CLJIList.h"
#import "CLJIPending.h"
#import "CLJIHashEq.h"
#import "CLJIPersistentMap.h"

typedef id(^CLJLazySeqGenerator)();

@interface CLJLazySeq : NSObject <CLJISeq, CLJISequential, CLJIList, CLJIPending, CLJIHashEq> {
@package
	id<CLJIPersistentMap> _meta;
}

- (id)initWithGenerator:(CLJLazySeqGenerator)g;
- (id)initWithMeta:(id<CLJIPersistentMap>)meta seq:(id<CLJISeq>)seq;

@end
