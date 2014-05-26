//
//  CLJILookup.h
//  PersistentStructure
//
//  Created by Robert Widmann on 12/29/13.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

@protocol CLJILookup <NSObject>
- (id)objectForKey:(id)key;
- (id)objectForKey:(id)key default:(id)notFound;
@end
