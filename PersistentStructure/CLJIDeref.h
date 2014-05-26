//
//  CLJIDeref.h
//  PersistentStructure
//
//  Created by Robert Widmann on 12/31/13.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

/// The CLJIDeref protocol defines the method an object that can dereferenced must implemented.
@protocol CLJIDeref <NSObject>

/// Returns the value contained in the reference object.
- (id)deref;

@end
