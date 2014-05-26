//
//  CLJISequential.h
//  PersistentStructure
//
//  Created by Robert Widmann on 12/29/13.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import <Foundation/Foundation.h>

/// The CLJISequential protocol acts as a marker that a class admits fast (generally constant or
/// logarithmic time) sequential access to values.
@protocol CLJISequential <NSObject>

@end
