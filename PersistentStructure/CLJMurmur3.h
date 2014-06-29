//
//  CLJMurmur3.h
//  PersistentStructure
//
//  Created by IDA WIDMANN on 6/24/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLJMurmur3 : NSObject

+ (NSUInteger)hashOrdered:(id<NSFastEnumeration>)xs;
+ (NSUInteger)hashUnordered:(id<NSFastEnumeration>)xs;

@end
