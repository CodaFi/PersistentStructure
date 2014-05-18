//
//  CLJBitmapIndexedNode.m
//  PersistentStructure
//
//  Created by Robert Widmann on 3/22/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJBitmapIndexedNode.h"
#import "CLJMapEntry.h"
#import "CLJNodeSeq.h"
#import "CLJBox.h"
#import "CLJUtils.h"
#import "CLJArrayNode.h"

@implementation CLJBitmapIndexedNode {
	NSInteger _bitmap;
	NSThread *_edit;
}

static CLJBitmapIndexedNode *EMPTY;

+ (void)load {
	if (self.class != CLJBitmapIndexedNode.class) {
		return;
	}
	EMPTY = [CLJBitmapIndexedNode createOnThread:nil bitmap:0 array:CLJArrayCreate(0)];
}

+ (CLJBitmapIndexedNode *)empty {
	return EMPTY;
}

- (NSInteger)index:(NSInteger)bit {
	return [CLJUtils bitCount:_bitmap & (bit - 1)];
}

+ (id)createOnThread:(NSThread *)edit bitmap:(NSInteger)bitmap array:(CLJArray)array {
	CLJBitmapIndexedNode *node = [[CLJBitmapIndexedNode alloc] init];
	
	node->_bitmap = bitmap;
	node->_array = array;
	node->_edit = edit;
	
	return node;
}

- (id<CLJINode>)assocWithShift:(NSInteger)shift hash:(NSInteger)hash key:(id)key value:(id)val addedLeaf:(CLJBox *)addedLeaf {
	NSInteger bit = [CLJUtils bitPos:hash shift:shift];
	NSInteger idx = [self index:bit];
	if ((_bitmap & bit) != 0) {
		id keyOrNull = _array.array[2 * idx];
		id valOrNode = _array.array[2 * idx+1];
		if (keyOrNull == nil) {
			id<CLJINode> n = [((id<CLJINode>) valOrNode) assocWithShift:shift + 5 hash:hash key:key value:val addedLeaf:addedLeaf];
			if (n == valOrNode) {
				return self;
			}
			return [CLJBitmapIndexedNode createOnThread:nil bitmap:_bitmap array:[CLJUtils cloneAndSetObject:_array index:2 * idx+1 node:n]];
		}
		if ([CLJUtils equiv:(__bridge void *)(key) other:(__bridge void *)(keyOrNull)]) {
			if (val == valOrNode) {
				return self;
			}
			return [CLJBitmapIndexedNode createOnThread:nil bitmap:_bitmap array:[CLJUtils cloneAndSetObject:_array index:2 * idx+1 node:val]];
		}
		addedLeaf.val = addedLeaf;
		return [CLJBitmapIndexedNode createOnThread:nil bitmap:_bitmap array:[CLJUtils cloneAndSet:_array index:2 * idx withObject:nil index:2 * idx+1 withObject:[CLJUtils createNodeWithShift:shift + 5 key:keyOrNull value:valOrNode hash:hash key:key value:val]]];
	} else {
		NSInteger n = [CLJUtils bitCount:_bitmap];
		if (n >= 16) {
			CLJArray nodes = CLJArrayCreate(32);
			NSInteger jdx = [CLJUtils mask:hash shift:shift];
			nodes.array[jdx] = [EMPTY assocWithShift:shift + 5 hash:hash key:key value:val addedLeaf:addedLeaf];
			NSInteger j = 0;
			for (NSInteger i = 0; i < 32; i++) {
				if (((_bitmap >> i) & 1) != 0) {
					if (_array.array[j] == nil) {
						nodes.array[i] = (id<CLJINode>) _array.array[j+1];
					} else {
						nodes.array[i] = [EMPTY assocWithShift:shift + 5 hash:[CLJUtils hash:_array.array[j]] key:_array.array[j] value:_array.array[j+1] addedLeaf:addedLeaf];
					}
					j += 2;
				}
			}
			return [CLJArrayNode createOnThread:nil count:n + 1 array:nodes];
		} else {
			CLJArray newArray = CLJArrayCreate(2 * (n+1));
			CLJArrayCopy(_array, 0, newArray, 0, 2 * idx);
			newArray.array[2 * idx] = key;
			addedLeaf.val = addedLeaf;
			newArray.array[2 * idx+1] = val;
			CLJArrayCopy(_array, 2 * idx, newArray, 2 * (idx+1), 2 * (n-idx));
			return [CLJBitmapIndexedNode createOnThread:nil bitmap:_bitmap | bit array:newArray];
		}
	}
}

- (id<CLJINode>)withoutWithShift:(NSInteger)shift hash:(NSInteger)hash key:(id)key {
	NSInteger bit = [CLJUtils bitPos:hash shift:shift];
	if ((_bitmap & bit) == 0) {
		return self;
	}
	NSInteger idx = [self index:bit];
	id keyOrNull = _array.array[2 * idx];
	id valOrNode = _array.array[2 * idx+1];
	if (keyOrNull == nil) {
		id<CLJINode> n = [((id<CLJINode>) valOrNode) withoutWithShift:shift + 5 hash:hash key:key];
		if (n == valOrNode) {
			return self;
		}
		if (n != nil) {
			return [CLJBitmapIndexedNode createOnThread:nil bitmap:_bitmap array:[CLJUtils cloneAndSetNode:_array index:2 * idx+1 node:n]];
		}
		if (_bitmap == bit) {
			return nil;
		}
		return [CLJBitmapIndexedNode createOnThread:nil bitmap:_bitmap ^ bit array:[CLJUtils removePair:_array index:idx]];
	}
	if ([CLJUtils equiv:(__bridge void *)(key) other:(__bridge void *)(keyOrNull)]) {
		// TODO: collapse
		return [CLJBitmapIndexedNode createOnThread:nil bitmap:_bitmap ^ _bitmap array:[CLJUtils removePair:_array index:idx]];
	}
	return self;
}

- (id<CLJIMapEntry>)findWithShift:(NSInteger)shift hash:(NSInteger)hash key:(id)key {
	NSInteger bit = [CLJUtils bitPos:hash shift:shift];
	if ((_bitmap & bit) == 0) {
		return nil;
	}
	NSInteger idx = [self index:bit];
	id keyOrNull = _array.array[2 * idx];
	id valOrNode = _array.array[2 * idx+1];
	if (keyOrNull == nil) {
		return [((id<CLJINode>) valOrNode) findWithShift:shift + 5 hash:hash key:key];
	}
	if ([CLJUtils equiv:(__bridge void *)(key) other:(__bridge void *)(keyOrNull)]) {
		return [[CLJMapEntry alloc] initWithKey:keyOrNull val:valOrNode];
	}
	return nil;
}

- (id)findWithShift:(NSInteger)shift hash:(NSInteger)hash key:(id)key notFound:(id)notFound {
	NSInteger bit = [CLJUtils bitPos:hash shift:shift];
	if ((_bitmap & bit) == 0)
		return notFound;
	NSInteger idx = [self index:bit];
	id keyOrNull = _array.array[2 * idx];
	id valOrNode = _array.array[2 * idx+1];
	if (keyOrNull == nil) {
		return [((id<CLJINode>) valOrNode) findWithShift:shift + 5 hash:hash key:key notFound:notFound];
	}
	if ([CLJUtils equiv:(__bridge void *)(key) other:(__bridge void *)(keyOrNull)]) {
		return valOrNode;
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

- (id)ensureEditable:(NSThread *)thread {
	if (_edit != thread) {
		return self;
	}
	NSInteger n = [CLJUtils bitCount:_bitmap];
	CLJArray newArray = CLJArrayCreate(n >= 0 ? 2 * (n+1) : 4);
	CLJArrayCopy(_array, 0, newArray, 0, 2 * n);
	return [CLJBitmapIndexedNode createOnThread:_edit bitmap:_bitmap array:newArray];
}

- (CLJBitmapIndexedNode *)editAndSet:(NSThread *)edit index:(NSInteger)i object:(id)a {
	CLJBitmapIndexedNode *editable = [self ensureEditable:edit];
	editable->_array.array[i] = a;
	return editable;
}

- (CLJBitmapIndexedNode *)editAndSet:(NSThread *)edit index:(NSInteger)i withObject:(id)a index:(NSInteger)j withObject:(id)b {
	CLJBitmapIndexedNode *editable = [self ensureEditable:edit];
	editable->_array.array[i] = a;
	editable->_array.array[j] = b;
	return editable;
}

- (CLJBitmapIndexedNode *)editAndRemovePair:(NSThread *)edit bit:(NSInteger)bit index:(NSInteger)i {
	if (_bitmap == bit) {
		return nil;
	}
	CLJBitmapIndexedNode *editable = [self ensureEditable:edit];
	editable->_bitmap ^= bit;
	CLJArrayCopy(editable->_array, 2 * (i+1), editable->_array, 2 * i, editable->_array.length - 2 * (i+1));
	editable->_array.array[editable->_array.length - 2] = nil;
	editable->_array.array[editable->_array.length - 1] = nil;
	return editable;
}

- (id<CLJINode>)assocOnThread:(NSThread *)edit shift:(NSInteger)shift hash:(NSInteger)hash key:(id)key val:(id)val addedLeaf:(CLJBox *)addedLeaf {
	NSInteger bit = [CLJUtils bitPos:hash shift:shift];
	NSInteger idx = [self index:bit];
	if ((_bitmap & bit) != 0) {
		id keyOrNull = _array.array[2 * idx];
		id valOrNode = _array.array[2 * idx+1];
		if (keyOrNull == nil) {
			id<CLJINode> n = [((id<CLJINode>)valOrNode) assocOnThread:edit shift:shift + 5 hash:hash key:key val:val addedLeaf:addedLeaf];
			if (n == valOrNode) {
				return self;
			}
			return [self editAndSet:edit index:2 * idx+1 object:n];
		}
		if ([CLJUtils equiv:(__bridge void *)(key) other:(__bridge void *)(keyOrNull)]) {
			if (val == valOrNode) {
				return self;
			}
			return [self editAndSet:edit index:2 * idx+1 object:val];
		}
		addedLeaf.val = addedLeaf;
		return [self editAndSet:edit index:2 * idx withObject:nil index:2 * idx+1 withObject:[CLJUtils createNodeOnThread:edit shift:shift + 5 key:keyOrNull value:valOrNode hash:hash key:key value:val]];
	} else {
		NSInteger n = [CLJUtils bitCount:_bitmap];
		if (n*2 < _array.length) {
			addedLeaf.val = addedLeaf;
			CLJBitmapIndexedNode *editable = [self ensureEditable:edit];
			CLJArrayCopy(editable->_array, 2 * idx, editable->_array, 2 * (idx+1), 2 * (n-idx));
			editable->_array.array[2 * idx] = key;
			editable->_array.array[2 * idx+1] = val;
			editable->_bitmap |= bit;
			return editable;
		}
		if (n >= 16) {
			CLJArray nodes = CLJArrayCreate(32);
			NSInteger jdx = [CLJUtils mask:hash shift:shift];
			nodes.array[jdx] = [EMPTY assocOnThread:edit shift:shift + 5 hash:hash key:key val:val addedLeaf:addedLeaf];
			NSInteger j = 0;
			for (NSInteger i = 0; i < 32; i++) {
				if (((_bitmap >> i) & 1) != 0) {
					if (_array.array[j] == nil) {
						nodes.array[i] = (id<CLJINode>)_array.array[j+1];
					} else {
						nodes.array[i] = [EMPTY assocOnThread:edit shift:shift + 5 hash:[CLJUtils hash:_array.array[j]] key:_array.array[j] val:_array.array[j+1] addedLeaf:addedLeaf];
					}
					j += 2;
				}
			}
			return [CLJArrayNode createOnThread:edit count:n + 1 array:nodes];
		} else {
			CLJArray newArray = CLJArrayCreate(2 * (n+4));
			CLJArrayCopy(_array, 0, newArray, 0, 2 * idx);
			newArray.array[2 * idx] = key;
			addedLeaf.val = addedLeaf;
			newArray.array[2 * idx+1] = val;
			CLJArrayCopy(_array, 2 * idx, newArray, 2 * (idx+1), 2 * (n-idx));
			CLJBitmapIndexedNode *editable = [self ensureEditable:edit];
			editable->_array = newArray;
			editable->_bitmap |= bit;
			return editable;
		}
	}
}

- (id<CLJINode>)withoutOnThread:(NSThread *)edit shift:(NSInteger)shift hash:(NSInteger)hash key:(id)key addedLeaf:(CLJBox *)removedLeaf {
	NSInteger bit = [CLJUtils bitPos:hash shift:shift];
	if ((_bitmap & bit) == 0) {
		return self;
	}
	NSInteger idx = [self index:bit];
	id keyOrNull = _array.array[2 * idx];
	id valOrNode = _array.array[2 * idx+1];
	if (keyOrNull == nil) {
		id<CLJINode> n = [((id<CLJINode>) valOrNode) withoutOnThread:edit shift:shift + 5 hash:hash key:key addedLeaf:removedLeaf];
		if (n == valOrNode) {
			return self;
		}
		if (n != nil) {
			return [self editAndSet:edit index:2 * idx+1 object:n];
		}
		if (_bitmap == bit) {
			return nil;
		}
		return [self editAndRemovePair:edit bit:bit index:idx];
	}
	if ([CLJUtils equiv:(__bridge void *)(key) other:(__bridge void *)(keyOrNull)]) {
		removedLeaf.val = removedLeaf;
		// TODO: collapse
		return [self editAndRemovePair:edit bit:bit index:idx];
	}
	return self;
}

@end
