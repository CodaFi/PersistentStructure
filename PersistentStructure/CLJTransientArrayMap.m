//
//  CLJTransientArrayMap.m
//  PersistentStructure
//
//  Created by Robert Widmann on 3/28/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJTransientArrayMap.h"
#import "CLJPersistentArrayMap.h"
#import "CLJPersistentHashMap.h"
#import "CLJTransientHashMap.h"
#import "CLJInterfaces.h"
#import "CLJUtils.h"

static const NSInteger HASHTABLE_THRESHOLD = 16;

@implementation CLJTransientArrayMap {
	NSInteger _length;
	CLJArray _array;
	NSThread *_owner;
}

- (id)initWithArray:(CLJArray)array {
	self = [super init];
	
	_owner = NSThread.currentThread;
	_array = CLJArrayCreate(MAX(HASHTABLE_THRESHOLD, _array.length));
	CLJArrayCopy(array, 0, _array, 0, array.length);
	_length = array.length;
	
	return self;
}

- (NSInteger)indexOf:(id)key {
	for (NSUInteger i = 0; i < _length; i += 2) {
		if ([CLJTransientArrayMap equalKey:_array.array[i] other:key]) {
			return i;
		}
	}
	return -1;
}

+ (BOOL)equalKey:(id)k1 other:(id)k2 {
	//    if ([k1 isKindOfClass:CLJKeyword.class])
	//        return k1 == k2;
	return [CLJUtils equiv:(__bridge void *)(k1) other:(__bridge void *)(k2)];
}

- (id<CLJITransientMap>)doassociateKey:(id)key :(id)val {
	NSInteger i = [self indexOf:key];
	if (i >= 0) { //already have key,
		if (_array.array[i + 1] != val) { //no change, no op
			_array.array[i + 1] = val;
		}
	} else { //didn't have key, grow
		if (_length >= _array.length) {
			return [[[CLJPersistentHashMap createWithMeta:nil array:_array] asTransient] associateKey:key value:val];
		}
		_array.array[_length++] = key;
		_array.array[_length++] = val;
	}
	return self;
}

- (id<CLJITransientMap>)doWithout:(id)key  {
	NSInteger i = [self indexOf:key];
	//have key, will remove
	if (i >= 0) {
		if (_length >= 2) {
			_array.array[i] = _array.array[_length - 2];
			_array.array[i + 1] = _array.array[_length - 1];
		}
		_length -= 2;
	}
	return self;
}

- (id)doobjectForKey:(id)key default:(id)notFound {
	NSInteger i = [self indexOf:key];
	if (i >= 0) {
		return _array.array[i + 1];
	}
	return notFound;
}

- (NSInteger)doCount {
	return _length / 2;
}

- (id<CLJIPersistentMap>)doPersistent {
	[self ensureEditable];
	_owner = nil;
	CLJArray a = CLJArrayCreate(_length);
	CLJArrayCopy(_array,0,a,0,_length);
	return [[CLJPersistentArrayMap alloc] initWithArray:a];
}

- (void)ensureEditable {
	if (_owner == NSThread.currentThread) {
		return;
	}
	if (_owner != nil) {
		[NSException raise:NSInternalInconsistencyException format:@"Transient used by non-owner thread"];
	}
	[NSException raise:NSInternalInconsistencyException format:@"Transient used after call to be made persistent"];
}

@end
