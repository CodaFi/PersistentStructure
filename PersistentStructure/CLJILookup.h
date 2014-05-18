//
//  CLJILookup.h
//  PersistentStructure
//
//  Created by Robert Widmann on 12/29/13.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

@protocol CLJILookup <NSObject>
- (id)valAt:(id)key;
- (id)valAt:(id)key default:(id)notFound;
@end
