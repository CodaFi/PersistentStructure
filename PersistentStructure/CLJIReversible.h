//
//  CLJReversible.h
//  PersistentStructure
//
//  Created by Robert Widmann on 12/29/13.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJISeq.h"

@protocol CLJReversible <NSObject>

- (id<CLJISeq>)reversedSeq;

@end
