//
//  CLJINode.h
//  PersistentStructure
//
//  Created by Robert Widmann on 12/30/13.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#include "CLJTypes.h"

@class CLJBox;
@protocol CLJIMapEntry, CLJISeq;

@protocol CLJINode <NSObject>

- (id<CLJINode>)assocWithShift:(NSInteger)shift hash:(NSInteger)hash key:(id)key value:(id)val addedLeaf:(CLJBox *)addedLeaf;
- (id<CLJINode>)withoutWithShift:(NSInteger)shift hash:(NSInteger)hash key:(id)key;
- (id<CLJIMapEntry>)findWithShift:(NSInteger)shift hash:(NSInteger)hash key:(id)key;
- (id)findWithShift:(NSInteger)shift hash:(NSInteger)hash key:(id)key notFound:(id)notFound;
- (id<CLJISeq>)nodeSeq;
- (id<CLJINode>)assocOnThread:(NSThread *)edit shift:(NSInteger)shift hash:(NSInteger)hash key:(id)key val:(id)val addedLeaf:(CLJBox *)addedLeaf;
- (id<CLJINode>)withoutOnThread:(NSThread *)edit shift:(NSInteger)shift hash:(NSInteger)hash key:(id)key addedLeaf:(CLJBox *)removedLeaf;
- (id)kvreduce:(CLJIKeyValueReduceBlock)f init:(id)init;
//- (id)fold:(IFn)combinef reduce:(IFn)reducef fjtask:(IFn)fjtask fjfork:(IFn)fjfork fjjoin:(IFn)fjjoin;

@end
