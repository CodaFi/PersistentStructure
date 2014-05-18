//
//  CLJHashCollisionNode.m
//  PersistentStructure
//
//  Created by Robert Widmann on 3/26/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJHashCollisionNode.h"
#import "CLJBitmapIndexedNode.h"
#import "CLJMapEntry.h"
#import "CLJNodeSeq.h"
#import "CLJBox.h"
#import "CLJUtils.h"

@implementation CLJHashCollisionNode {
	NSInteger _hash;
	NSInteger _count;
	CLJArray _array;
	NSThread *_edit;
}

- (id)initWithThread:(NSThread *)edit hash:(NSInteger)hash count:(NSInteger)count array:(CLJArray)array {
	self = [super init];
	_edit = edit;
	_hash = hash;
	_count = count;
	_array = array;
	return self;
}

- (id<CLJINode>)assocWithShift:(NSInteger)shift hash:(NSInteger)hash key:(id)key value:(id)val addedLeaf:(CLJBox *)addedLeaf {
	if (hash == _hash) {
		NSInteger idx = [self findIndex:key];
		if (idx != -1) {
			if (_array.array[idx + 1] == val) {
				return self;
			}
			return [[CLJHashCollisionNode alloc] initWithThread:nil hash:_hash count:_count array:[CLJUtils cloneAndSetObject:_array index:idx + 1 node:val]];
		}
		CLJArray newArray = CLJArrayCreate(2 * (_count + 1));
		CLJArrayCopy(_array, 0, newArray, 0, 2 * _count);
		newArray.array[2 * _count] = key;
		newArray.array[2 * _count + 1] = val;
		addedLeaf.val = addedLeaf;
		return [[CLJHashCollisionNode alloc] initWithThread:_edit hash:hash count:_count + 1 array:newArray];
	}
	// nest it in a bitmap node
	__strong id arr[2] = { nil, self };
	return [[CLJBitmapIndexedNode createOnThread:nil bitmap:[CLJUtils bitPos:_hash shift:shift] array:(CLJArray){
		.array = arr,
		.length = 2,
	}] assocWithShift:shift hash:hash key:key value:val addedLeaf:addedLeaf];
}

- (id<CLJINode>)withoutWithShift:(NSInteger)shift hash:(NSInteger)hash key:(id)key {
	NSInteger idx = [self findIndex:key];
	if (idx == -1) {
		return self;
	}
	if (_count == 1) {
		return nil;
	}
	return [[CLJHashCollisionNode alloc] initWithThread:nil hash:hash count:_count - 1 array:[CLJUtils removePair:_array index:idx/2]];
}

- (id<CLJIMapEntry>)findWithShift:(NSInteger)shift hash:(NSInteger)hash key:(id)key {
	NSInteger idx = [self findIndex:key];
	if (idx < 0) {
		return nil;
	}
	if ([CLJUtils equiv:(__bridge void *)(key) other:(__bridge void *)(_array.array[idx])]) {
		return [[CLJMapEntry alloc] initWithKey:_array.array[idx] val:_array.array[idx+1]];
	}
	return nil;
}

- (id)findWithShift:(NSInteger)shift hash:(NSInteger)hash key:(id)key notFound:(id)notFound {
	NSInteger idx = [self findIndex:key];
	if (idx < 0) {
		return notFound;
	}
	if ([CLJUtils equiv:(__bridge void *)(key) other:(__bridge void *)(_array.array[idx])]) {
		return _array.array[idx+1];
	}
	return notFound;
}

- (id<CLJISeq>)nodeSeq {
	return [[CLJNodeSeq alloc] initWithArray:_array];
}

- (id)kvreduce:(CLJIKeyValueReduceBlock)f init:(id)init {
	return [CLJNodeSeq kvreducearray:_array reducer:f init:init];
}

//public Object fold(IFn combinef, IFn reducef, IFn fjtask, IFn fjfork, IFn fjjoin){
//	return NodeSeq.kvreduce(array, reducef, combinef.invoke());
//}

- (NSInteger)findIndex:(id)key {
	for (NSInteger i = 0; i < 2 * _count; i+=2) {
		if ([CLJUtils equiv:(__bridge void *)(key) other:(__bridge void *)(_array.array[i])]) {
			return i;
		}
	}
	return -1;
}

- (CLJHashCollisionNode *)ensureEditable:(NSThread *)edit {
	if (_edit == edit) {
		return self;
	}
	CLJArray newArray = CLJArrayCreate(2 * (_count+1)); // make room for next assoc
	CLJArrayCopy(_array, 0, newArray, 0, 2 * _count);
	return [[CLJHashCollisionNode alloc] initWithThread:edit hash:_hash count:_count array:newArray];
}

- (CLJHashCollisionNode *)ensureEditable:(NSThread *)edit count:(NSInteger)count array:(CLJArray)array {
	if (_edit == edit) {
		_array = array;
		_count = count;
		return self;
	}
	return [[CLJHashCollisionNode alloc] initWithThread:edit hash:_hash count:count array:array];
}

- (CLJHashCollisionNode *)editAndSetOnThread:(NSThread *)edit index:(NSInteger)i withObject:(id)a {
	CLJHashCollisionNode * editable = [self ensureEditable:edit];
	editable->_array.array[i] = a;
	return editable;
}

- (CLJHashCollisionNode *)editAndSetOnThread:(NSThread *)edit index:(NSInteger)i withObject:(id)a index:(NSInteger)j withObject:(id)b {
	CLJHashCollisionNode * editable = [self ensureEditable:edit];
	editable->_array.array[i] = a;
	editable->_array.array[j] = b;
	return editable;
}

- (id<CLJINode>)assocOnThread:(NSThread *)edit shift:(NSInteger)shift hash:(NSInteger)hash key:(id)key val:(id)val addedLeaf:(CLJBox *)addedLeaf {
	if (hash == _hash) {
		NSInteger idx = [self findIndex:key];
		if (idx != -1) {
			if (_array.array[idx + 1] == val) {
				return self;
			}
			return [self editAndSetOnThread:edit index:idx+1 withObject:val];
		}
		if (_array.length > 2 * _count) {
			addedLeaf.val = addedLeaf;
			CLJHashCollisionNode *editable = [self editAndSetOnThread:edit index:2 * _count withObject:key index:2 * _count withObject:val];
			editable->_count++;
			return editable;
		}
		CLJArray newArray = CLJArrayCreate(_array.length + 2);
		CLJArrayCopy(_array, 0, newArray, 0, _array.length);
		newArray.array[_array.length] = key;
		newArray.array[_array.length + 1] = val;
		addedLeaf.val = addedLeaf;
		return [self ensureEditable:edit count:_count + 1 array:newArray];
	}
	// nest it in a bitmap node
	__strong id arr[4] = {nil, self, nil, nil};
	return [[CLJBitmapIndexedNode createOnThread:edit bitmap:[CLJUtils bitPos:_hash shift:shift] array:(CLJArray){
		.array = arr,
		.length = 4,
	}] assocOnThread:edit shift:shift hash:hash key:key val:val addedLeaf:addedLeaf];
}

- (id<CLJINode>)withoutOnThread:(NSThread *)edit shift:(NSInteger)shift hash:(NSInteger)hash key:(id)key addedLeaf:(CLJBox *)removedLeaf {
	NSInteger idx = [self findIndex:key];
	if (idx == -1) {
		return self;
	}
	removedLeaf.val = removedLeaf;
	if (_count == 1) {
		return nil;
	}
	CLJHashCollisionNode *editable = [self ensureEditable:edit];
	editable->_array.array[idx] = editable->_array.array[2 * _count-2];
	editable->_array.array[idx+1] = editable->_array.array[2 * _count-1];
	editable->_array.array[2 * _count-2] = editable->_array.array[2 * _count-1] = nil;
	editable->_count--;
	return editable;
}


@end
