//
//  CLJTreeNode.h
//  PersistentStructure
//
//  Created by Robert Widmann on 5/25/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//

#import "CLJMapEntry.h"

@interface CLJTreeNode : CLJMapEntry

- (id)initWithKey:(id)k;

- (CLJTreeNode *)addLeft:(CLJTreeNode *)ins;
- (CLJTreeNode *)addRight:(CLJTreeNode *)ins;
- (CLJTreeNode *)removeLeft:(CLJTreeNode *)del;
- (CLJTreeNode *)removeRight:(CLJTreeNode *)del;

- (CLJTreeNode *)blacken;
- (CLJTreeNode *)redden;


- (CLJTreeNode *)left;
- (CLJTreeNode *)right;

- (CLJTreeNode *)replaceKey:(id)key byValue:(id)val left:(CLJTreeNode *)left right:(CLJTreeNode *)right;

@end

@interface CLJBlackTreeNode : CLJTreeNode
@end

@interface CLJBlackTreeValue : CLJBlackTreeNode
@end

@interface CLJBlackTreeBranch : CLJBlackTreeNode
- (id)initWithKey:(id)k left:(CLJTreeNode *)left right:(CLJTreeNode *)right;
@end

@interface CLJBlackTreeBranchValue : CLJBlackTreeBranch
- (id)initWithKey:(id)key val:(id)val left:(CLJTreeNode *)left right:(CLJTreeNode *)right;
@end


@interface CLJRedTreeNode : CLJTreeNode
@end


@interface CLJRedTreeValue : CLJRedTreeNode
@end

@interface CLJRedTreeBranch : CLJRedTreeNode
- (id)initWithKey:(id)k left:(CLJTreeNode *)left right:(CLJTreeNode *)right;
@end

@interface CLJRedTreeBranchValue : CLJRedTreeBranch
- (id)initWithKey:(id)key val:(id)val left:(CLJTreeNode *)left right:(CLJTreeNode *)right;
@end

