//
//  CLJTransientHashMap.m
//  PersistentStructure
//
//  Created by Robert Widmann on 3/22/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJTransientHashMap.h"
#import "CLJBox.h"
#import "CLJInterfaces.h"
#import "CLJPersistentHashMap.h"
#import "CLJBitmapIndexedNode.h"
#import "CLJUtils.h"

@implementation CLJTransientHashMap {
	NSThread *_edit;
	id<CLJINode> _root;
	NSInteger _count;
	bool _hasNull;
	id _nullValue;
	CLJBox *_leafFlag;
}

+ (instancetype)create:(CLJPersistentHashMap *)m {
	return [CLJTransientHashMap createOnThread:NSThread.currentThread root:[m root] count:[m count] hasNull:[m hasNull] nullValue:[m nullValue]];
}

+ (instancetype)createOnThread:(NSThread *)thread root:(id<CLJINode>)root count:(NSInteger)count hasNull:(bool)hasNull nullValue:(id)nullValue {
	CLJTransientHashMap *map = [[CLJTransientHashMap alloc] init];
	map->_edit = thread;
	map->_root = root;
	map->_count = count;
	map->_hasNull = hasNull;
	map->_nullValue = nullValue;
	map->_leafFlag = [[CLJBox alloc] init];
	return map;
}

- (id<CLJITransientMap>)doassociateKey:(id)key :(id)val {
	if (key == nil) {
		if (_nullValue != val) {
			_nullValue = val;
		}
		if (!_hasNull) {
			_count++;
			_hasNull = true;
		}
		return self;
	}
	_leafFlag.val = nil;
	id<CLJINode> n = [(_root == nil ? CLJBitmapIndexedNode.empty : _root) assocOnThread:_edit shift:0 hash:[CLJUtils hash:key] key:key val:val addedLeaf:_leafFlag];
	if (n != _root) {
		_root = n;
	}
	if (_leafFlag.val != nil) _count++;
	return self;
}

- (id<CLJITransientMap>)doWithout:(id)key {
	if (key == nil) {
		if (!_hasNull) {
			return self;	
		}
		_hasNull = false;
		_nullValue = nil;
		_count--;
		return self;
	}
	if (_root == nil) return self;
	_leafFlag.val = nil;
	id<CLJINode> n = [_root withoutOnThread:_edit shift:0 hash:[CLJUtils hash:key] key:key addedLeaf:_leafFlag];
	if (n != _root) {
		_root = n;
	}
	if (_leafFlag.val != nil) _count--;
	return self;
}

- (id<CLJIPersistentMap>)doPersistent {
//	edit.set(null);
	return [[CLJPersistentHashMap alloc] initWithCount:_count root:_root hasNull:_hasNull nullValue:_nullValue];
}

- (id)doValAt:(id)key :(id)notFound {
	if (key == nil) {
		if (_hasNull) {
			return _nullValue;
		} else {
			return notFound;
		}
	}
	if (_root == nil) {
		return notFound;
	}
	return [_root findWithShift:0 hash:[CLJUtils hash:key] key:key notFound:notFound];
}

- (NSInteger)doCount {
	return _count;
}

- (void)ensureEditable {
	if (_edit == NSThread.currentThread) {
		return;
	}
	if (_edit != nil) {
		[NSException raise:NSInternalInconsistencyException format:@"Transient used by non-owner thread"];
	}
	[NSException raise:NSInternalInconsistencyException format:@"Transient used by call to be persistent"];
}

@end