//
//  CLJIMapEntry.h
//  PersistentStructure
//
//  Created by Robert Widmann on 12/29/13.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

@protocol CLJIMapEntry <NSObject>
- (id)key;
- (id)val;
- (BOOL)isEqual:(id)o;
- (id)setValue:(id)value;
@end
