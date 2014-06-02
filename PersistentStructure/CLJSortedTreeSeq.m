//
//  CLJSortedTreeSeq.m
//  PersistentStructure
//
//  Created by Robert Widmann on 6/1/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//

#import "CLJSortedTreeSeq.h"
#import "CLJTreeNode.h"
#import "CLJUtils.h"

@implementation CLJSortedTreeSeq {
	id<CLJISeq> _stack;
	BOOL _asc;
	NSInteger _cnt;
}

- (id)initWithStack:(id<CLJISeq>)stack ascending:(BOOL)asc {
	self = [super init];
	
	_stack = stack;
	_asc = asc;
	_cnt = -1;
	
	return self;
}

- (id)initWithStack:(id<CLJISeq>)stack ascending:(BOOL)asc count:(NSInteger)count {
	self = [super init];
	
	_stack = stack;
	_asc = asc;
	_cnt = count;
	
	return self;
}

- (instancetype)initWithMeta:(id<CLJIPersistentMap>)meta stack:(id<CLJISeq>)stack ascending:(BOOL)asc count:(NSInteger)count {
	self = [super initWithMeta:meta];
	
	_stack = stack;
	_asc = asc;
	_cnt = count;
	
	return self;
}

+ (CLJSortedTreeSeq *)createWithRoot:(CLJTreeNode *)t ascending:(BOOL)asc count:(NSInteger)cnt {
	return [[CLJSortedTreeSeq alloc] initWithStack:[CLJSortedTreeSeq pushNode:t stack:nil ascending:asc] ascending:asc count:cnt];
}

+ (id<CLJISeq>)pushNode:(CLJTreeNode *)t stack:(id<CLJISeq>)stack ascending:(BOOL)asc {
	while(t != nil) {
		stack = [CLJUtils cons:t to:stack];
		t = asc ? t.left : t.right;
	}
	return stack;
}

- (id)first {
	return _stack.first;
}

- (id<CLJISeq>)next {
	CLJTreeNode *t = (CLJTreeNode *)_stack.first;
	id<CLJISeq> nextstack = [CLJSortedTreeSeq pushNode:_asc ? t.right : t.left stack:_stack.next ascending:_asc];
	if(nextstack != nil) {
		return [[CLJSortedTreeSeq alloc] initWithStack:nextstack ascending:_asc count:_cnt - 1];
	}
	return nil;
}

- (NSUInteger)count {
	if(_cnt < 0) {
		return super.count;
	}
	return _cnt;
}

- (id<CLJIObj>)withMeta:(id<CLJIPersistentMap>)meta {
	return (id<CLJIObj>)[[CLJSortedTreeSeq alloc] initWithMeta:meta stack:_stack ascending:_asc count:_cnt];
}

@end
