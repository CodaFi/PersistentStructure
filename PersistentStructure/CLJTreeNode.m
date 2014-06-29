//
//  CLJTreeNode.m
//  PersistentStructure
//
//  Created by Robert Widmann on 5/25/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//

#import "CLJTreeNode.h"
#import "CLJPersistentTreeMap.h"

@interface CLJPersistentTreeMap (CLJInternal)

+ (CLJRedTreeNode *)red:(id)key val:(id)val left:(CLJTreeNode *)left right:(CLJTreeNode *)right;
+ (CLJRedTreeNode *)black:(id)key val:(id)val left:(CLJTreeNode *)left right:(CLJTreeNode *)right;

+ (CLJTreeNode *)balanceLeftDel:(id)key val:(id)val del:(CLJTreeNode *)del right:(CLJTreeNode *)right;
+ (CLJTreeNode *)balanceRightDel:(id)key val:(id)val del:(CLJTreeNode *)del left:(CLJTreeNode *)left;

+ (CLJTreeNode *)leftBalance:(id)key val:(id)val ins:(CLJTreeNode *)ins right:(CLJTreeNode *)right;
+ (CLJTreeNode *)rightBalance:(id)key val:(id)val left:(CLJTreeNode *)left ins:(CLJTreeNode *)ins;

@end

@implementation CLJTreeNode {
@package
	id _key;
}

- (id)initWithKey:(id)k {
	self = [super init];
	
	_key = k;
	
	return self;
}

- (id)key {
	return _key;
}

- (id)val {
	return nil;
}

- (CLJTreeNode *)left {
	return nil;
}

- (CLJTreeNode *)right {
	return nil;
}

- (CLJTreeNode *)addLeft:(CLJTreeNode *)ins {
	return nil;
}

- (CLJTreeNode *)addRight:(CLJTreeNode *)ins {
	return nil;
}

- (CLJTreeNode *)removeLeft:(CLJTreeNode *)del {
	return nil;
}

- (CLJTreeNode *)removeRight:(CLJTreeNode *)del {
	return nil;
}

- (CLJTreeNode *)blacken { return nil; };
- (CLJTreeNode *)redden { return nil; };

- (CLJTreeNode *)balanceLeft:(CLJTreeNode *)parent {
	return [CLJPersistentTreeMap black:parent.key val:parent.val left:self right:parent.right];
}

- (CLJTreeNode *)balanceRight:(CLJTreeNode *)parent {
	return [CLJPersistentTreeMap black:parent.key val:parent.val left:parent.left right:self];
}

- (CLJTreeNode *)replaceKey:(id)key byValue:(id)val left:(CLJTreeNode *)left right:(CLJTreeNode *)right {
	return nil;
}

@end

@implementation CLJBlackTreeNode


- (CLJTreeNode *)addLeft:(CLJTreeNode *)ins {
	return [ins balanceLeft:self];
}

- (CLJTreeNode *)addRight:(CLJTreeNode *)ins {
	return [ins balanceRight:self];
}

- (CLJTreeNode *)removeLeft:(CLJTreeNode *)del {
	return [CLJPersistentTreeMap balanceLeftDel:_key val:self.val del:del right:self.right];
}

- (CLJTreeNode *)removeRight:(CLJTreeNode *)del {
	return [CLJPersistentTreeMap balanceRightDel:_key val:self.val del:del left:self.left];
}

- (CLJTreeNode *)blacken {
	return self;
}

- (CLJTreeNode *)redden {
	return [[CLJRedTreeNode alloc] initWithKey:_key];
}

- (CLJTreeNode *)replaceKey:(id)key byValue:(id)val left:(CLJTreeNode *)left right:(CLJTreeNode *)right {
	return [CLJPersistentTreeMap black:key val:val left:left right:right];
}


@end

@implementation CLJBlackTreeValue {
	id _val;
}

- (id)initWithKey:(id)key val:(id)val {
	self = [super initWithKey:key];
	
	_val = val;
	
	return self;
}

- (id)val {
	return _val;
}

- (CLJTreeNode *)redden {
	return [[CLJRedTreeValue alloc] initWithKey:_key val:_val];
}

@end

@implementation CLJBlackTreeBranch {
@package
	CLJTreeNode *_left;
	CLJTreeNode *_right;
}

- (id)initWithKey:(id)k left:(CLJTreeNode *)left right:(CLJTreeNode *)right {
	self = [super initWithKey:k];
	
	_left = left;
	_right = right;
	
	return self;
}

- (CLJTreeNode *)left {
	return _left;
}

- (CLJTreeNode *)right {
	return _right;
}

- (CLJTreeNode *)redden {
	return [[CLJRedTreeBranch alloc] initWithKey:_key left:_left right:_right];
}

@end

@implementation CLJBlackTreeBranchValue {
	id _val;
}

- (id)initWithKey:(id)key val:(id)val left:(CLJTreeNode *)left right:(CLJTreeNode *)right {
	self = [super initWithKey:key left:left right:right];
	
	_val = val;
	
	
	return self;
}

- (id)val {
	return _val;
}

- (CLJTreeNode *)redden {
	return [[CLJRedTreeBranchValue alloc] initWithKey:_key val:_val left:_left right:_right];
}

@end

@implementation CLJRedTreeValue {
	id _val;
}

- (id)initWithKey:(id)key val:(id)val {
	self = [super initWithKey:key];
	
	_val = val;
	
	return self;
}

- (id)val {
	return _val;
}

- (CLJTreeNode *)blacken {
	return [[CLJBlackTreeValue alloc] initWithKey:_key val:_val];
}

@end

@implementation CLJRedTreeBranch {
	@package
	CLJTreeNode *_left;
	CLJTreeNode *_right;
}

- (id)initWithKey:(id)k left:(CLJTreeNode *)left right:(CLJTreeNode *)right {
	self = [super initWithKey:k];
	
	_left = left;
	_right = right;
	
	return self;
}

- (CLJTreeNode *)left {
	return _left;
}

- (CLJTreeNode *)right {
	return _right;
}

- (CLJTreeNode *)balanceLeft:(CLJTreeNode *)parent {
	if([_left isKindOfClass:CLJRedTreeNode.class]) {
		return [CLJPersistentTreeMap red:_key val:self.val left:_left.blacken right:[CLJPersistentTreeMap black:parent.key val:parent.val left:_right right:parent.right]];
	} else if([_right isKindOfClass:CLJRedTreeNode.class]) {
		return [CLJPersistentTreeMap red:_right.key val:_right.val left:_right.left right:[CLJPersistentTreeMap black:parent.key val:parent.val left:_right.right right:parent.right]];
	} else {
		return [super balanceLeft:parent];
	}
	
}

- (CLJTreeNode *)balanceRight:(CLJTreeNode *)parent  {
	if([_right isKindOfClass:CLJRedTreeNode.class]) {
		return [CLJPersistentTreeMap red:_key val:self.val left:[CLJPersistentTreeMap black:parent.key val:parent.val left:parent.left right:_left] right:_right.blacken];
	} else if([_left isKindOfClass:CLJRedTreeNode.class]) {
		return [CLJPersistentTreeMap red:_left.key val:_left.val
									left:[CLJPersistentTreeMap black:parent.key val:parent.val left:parent.left right:_left.left]
								   right:[CLJPersistentTreeMap black:_key val:self.val left:_left.right right:_right]];
	} else {
		return [super balanceRight:parent];
	}
}

- (CLJTreeNode *)blacken {
	return [[CLJBlackTreeBranch alloc] initWithKey:_key left:_left right:_right];
}

@end

@implementation CLJRedTreeBranchValue {
	id _val;
}

- (id)initWithKey:(id)key val:(id)val left:(CLJTreeNode *)left right:(CLJTreeNode *)right {
	self = [super initWithKey:key left:left right:right];
	
	_val = val;
		
	return self;
}

- (id)val {
	return _val;
}

- (CLJTreeNode *)blacken {
	return [[CLJBlackTreeBranchValue alloc] initWithKey:_key val:_val left:_left right:_right];
}

@end



