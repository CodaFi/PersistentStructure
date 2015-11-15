//
//  CLJArrayNode.m
//  PersistentStructure
//
//  Created by Robert Widmann on 3/26/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJArrayNode.h"
#import "CLJUtils.h"
#import "CLJBitmapIndexedNode.h"
#import "CLJSeq.h"

@implementation CLJArrayNode {
	NSInteger _count;
	CLJArray _array; //id<CLJINode> *
	NSThread *_edit;
}

+ (id)createOnThread:(NSThread *)edit count:(NSInteger)count array:(CLJArray)array {
	CLJArrayNode *node = [[CLJArrayNode alloc] init];
	
	node->_edit = edit;
	node->_count = count;
	node->_array = array;
	
	return node;
}

- (id<CLJINode>)assocWithShift:(NSInteger)shift hash:(NSInteger)hash key:(id)key value:(id)val addedLeaf:(CLJBox *)addedLeaf {
	NSInteger idx = [CLJUtils mask:hash shift:shift];
	id<CLJINode> node = (id<CLJINode>)_array.array[idx];
	if (node == nil) {
		return [CLJArrayNode createOnThread:nil count:_count + 1 array:[CLJUtils cloneAndSetNode:_array index:idx node:[CLJBitmapIndexedNode.empty assocWithShift:shift + 5 hash:hash key:key value:val addedLeaf:addedLeaf]]];
	}
	id<CLJINode> n = [node assocWithShift:shift + 5 hash:hash key:key value:val addedLeaf:addedLeaf];
	if (n == node) {
		return self;
	}
	return [CLJArrayNode createOnThread:nil count:_count array:[CLJUtils cloneAndSetNode:_array index:idx node:n]];
}

- (id<CLJINode>)withoutWithShift:(NSInteger)shift hash:(NSInteger)hash key:(id)key {
	NSInteger idx = [CLJUtils mask:hash shift:shift];
	id<CLJINode> node = (id<CLJINode>)_array.array[idx];
	if (node == nil) {
		return self;
	}
	id<CLJINode> n = [node withoutWithShift:shift + 5 hash:hash key:key];
	if (n == node) {
		return self;
	}
	if (n == nil) {
		if (_count <= 8) { // shrink
			return [self packOnThread:nil index:idx];
		}
		return [CLJArrayNode createOnThread:nil count:_count - 1 array:[CLJUtils cloneAndSetNode:_array index:idx node:n]];
	} else {
		return [CLJArrayNode createOnThread:nil count:_count array:[CLJUtils cloneAndSetNode:_array index:idx node:n]];
	}
}

- (id)findWithShift:(NSInteger)shift hash:(NSInteger)hash key:(id)key {
	NSInteger idx = [CLJUtils mask:hash shift:shift];
	id<CLJINode> node = _array.array[idx];
	if (node == nil) {
		return nil;
	}
	return [node findWithShift:shift + 5 hash:hash key:key];
}

- (id)findWithShift:(NSInteger)shift hash:(NSInteger)hash key:(id)key notFound:(id)notFound {
	NSInteger idx = [CLJUtils mask:hash shift:shift];
	id<CLJINode> node = _array.array[idx];
	if (node == nil) {
		return nil;
	}
	return [node findWithShift:shift + 5 hash:hash key:key notFound:notFound];
}

- (id<CLJISeq>)nodeSeq {
	return [CLJSeq create:_array];
}

- (id)kvreduce:(CLJIKeyValueReduceBlock)f init:(id)init {
	for (NSUInteger i = 0; i < _array.length; i++){
		id<CLJINode> node = _array.array[i];
		if (node != nil){
			init = [node kvreduce:f init:init];
			if ([CLJUtils isReduced:init]) {
				return ((id<CLJIDeref>)init).deref;
			}
		}
	}
	return init;
}

- (CLJArrayNode *)ensureEditable:(NSThread *)edit {
	if (_edit == edit) {
		return self;
	}
	return [CLJArrayNode createOnThread:edit count:_count array:_array];
}

- (CLJArrayNode *)editAndSetOnThread:(NSThread *)edit index:(NSInteger)i node:(id<CLJINode>)n {
	CLJArrayNode *editable = [self ensureEditable:edit];
	editable->_array.array[i] = n;
	return editable;
}

- (id<CLJINode>)packOnThread:(NSThread *)edit index:(NSInteger)idx {
	CLJArray newArray = CLJArrayCreate(2 * (_count - 1));
	NSInteger j = 1;
	NSInteger bitmap = 0;
	for (NSInteger i = 0; i < idx; i++) {
		if (_array.array[i] != nil) {
			newArray.array[j] = _array.array[i];
			bitmap |= 1 << i;
			j += 2;
		}
	}
	for (NSInteger i = idx + 1; i < _array.length; i++) {
		if (_array.array[i] != nil) {
			newArray.array[j] = _array.array[i];
			bitmap |= 1 << i;
			j += 2;
		}
	}
	return [CLJBitmapIndexedNode createOnThread:edit bitmap:bitmap array:newArray];
}

- (id<CLJINode>)assocOnThread:(NSThread *)edit shift:(NSInteger)shift hash:(NSInteger)hash key:(id)key val:(id)val addedLeaf:(CLJBox *)addedLeaf {
	NSInteger idx = [CLJUtils mask:hash shift:shift];
	id<CLJINode> node = _array.array[idx];
	if (node == nil) {
		CLJArrayNode *editable = [self editAndSetOnThread:edit index:idx node:[CLJBitmapIndexedNode.empty assocOnThread:edit shift:shift + 5 hash:hash key:key val:val addedLeaf:addedLeaf]];
		editable->_count++;
		return editable;
	}
	id<CLJINode> n = [node assocOnThread:edit shift:shift + 5 hash:hash key:key val:val addedLeaf:addedLeaf];
	if (n == node) {
		return self;
	}
	return [self editAndSetOnThread:edit index:idx node:n];
}

- (id<CLJINode>)withoutOnThread:(NSThread *)edit shift:(NSInteger)shift hash:(NSInteger)hash key:(id)key addedLeaf:(CLJBox *)removedLeaf {
	NSInteger idx = [CLJUtils mask:hash shift:shift];
	id<CLJINode> node = _array.array[idx];
	if (node == nil) {
		return self;
	}
	id<CLJINode> n = [node withoutOnThread:edit shift:shift + 5 hash:hash key:key addedLeaf:removedLeaf];
	if (n == node) {
		return self;
	}
	if (n == nil) {
		if (_count <= 8) { // shrink
			return [self packOnThread:edit index:idx];
		}
		CLJArrayNode *editable = [self editAndSetOnThread:edit index:idx node:n];
		editable->_count--;
		return editable;
	}
	return [self editAndSetOnThread:edit index:idx node:n];
}

@end
