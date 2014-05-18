//
//  CLJUtils.h
//  PersistentStructure
//
//  Created by Robert Widmann on 12/29/13.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJArray.h"
#import "CLJInterfaces.h"

@protocol CLJISeq;

@interface CLJUtils : NSObject

+ (id<CLJISeq>)next:(id)x;
+ (id<CLJISeq>)more:(id)x;

+ (id)first:(id)x;
+ (id)second:(id)x;
+ (id)third:(id)x;
+ (id)fourth:(id)x;

+ (BOOL)isReduced:(id)x;
+ (BOOL)isInteger:(id)obj;
+ (id<CLJISeq>)seq:(id)coll;
+ (BOOL)isEqual:(id)k1 other:(id)k2;
+ (BOOL)equiv:(void *)k1 other:(void *)k2;
+ (NSInteger)hasheq:(id)o;
+ (CLJArray)seqToArray:(id<CLJISeq>)seq;
+ (NSInteger)count:(id)coll;
+ (id)nthOf:(id)coll index:(NSInteger)index;
+ (id<CLJISeq>)cons:(id)o to:(id)seq;
+ (id<CLJIPersistentCollection>)conj:(id)x to:(id<CLJIPersistentCollection>)coll;
+ (id<CLJIAssociative>)associateKey:(id)key to:(id)val in:(id)coll;
+ (BOOL)containsObject:(id)coll key:(id)key;

+ (id<CLJIPersistentVector>)subvecOf:(id<CLJIPersistentVector>)v start:(NSInteger)start end:(NSInteger)end;
+ (NSUInteger)hash:(id)obj;
+ (CLJArray)_emptyArray;

+ (NSInteger)bitCount:(NSUInteger)num;
+ (NSInteger)bitPos:(NSInteger)hash shift:(NSInteger)shift;
+ (NSInteger)mask:(NSInteger)x shift:(NSInteger)n;

+ (CLJArray /*id<CLJINode>[]*/)cloneAndSetNode:(CLJArray)array index:(NSInteger)i node:(id<CLJINode>)a;
+ (CLJArray /*id<CLJINode>[]*/)cloneAndSetObject:(CLJArray)array index:(NSInteger)i node:(id)a;
+ (CLJArray)cloneAndSet:(CLJArray)array index:(NSInteger)i withObject:(id)a index:(NSInteger)j withObject:(id)b;
+ (CLJArray)removePair:(CLJArray)array index:(NSInteger)i;


+ (id<CLJINode>)createNodeWithShift:(NSInteger)shift key:(id)key1 value:(id)val1 hash:(NSInteger)key2hash key:(id)key2 value:(id)val2;
+ (id<CLJINode>)createNodeOnThread:(NSThread *)edit shift:(NSInteger)shift key:(id)key1 value:(id)val1 hash:(NSInteger)key2hash key:(id)key2 value:(id)val2;

+ (NSComparisonResult)compare:(id)k1 to:(id)k2;
@end
