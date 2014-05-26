//
//  CLJIIndexed.h
//  PersistentStructure
//
//  Created by Robert Widmann on 12/29/13.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJICounted.h"

@protocol CLJIIndexed <CLJICounted>
- (id)objectAtIndex:(NSInteger)i;
- (id)objectAtIndex:(NSInteger)i default:(id)notFound;
@end
