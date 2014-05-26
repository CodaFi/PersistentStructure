//
//  _CLJTransientMap.h
//  PersistentStructure
//
//  Created by Robert Widmann on 12/31/13.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJITransientMap.h"

@interface CLJAbstractTransientMap : NSObject <CLJITransientMap>

- (void)ensureEditable;
- (id<CLJITransientMap>)doassociateKey:(id)key :val;
- (id<CLJITransientMap>)doWithout:(id)key;
- (id)doobjectForKey:(id)key :notFound;
- (NSInteger)doCount;
- (id<CLJIPersistentMap>)doPersistent;

@end
