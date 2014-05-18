//
//  CLJSeq.h
//  PersistentStructure
//
//  Created by Robert Widmann on 12/29/13.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

@protocol CLJIPersistentCollection;

@protocol CLJISeq <CLJIPersistentCollection>

- (id)first;
- (id<CLJISeq>)next;
- (id<CLJISeq>)more;
- (id<CLJISeq>)cons:(id)other;

@end
