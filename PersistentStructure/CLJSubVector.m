//
//  CLJSubVector.m
//  PersistentStructure
//
//  Created by Robert Widmann on 3/26/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJSubVector.h"
#import "CLJInterfaces.h"
#import "CLJPersistentVector.h"

@implementation CLJSubVector {
	id<CLJIPersistentVector> _v;
	NSInteger _start;
	NSInteger _end;
	id<CLJIPersistentMap> _meta;
}

- (id)initWithMeta:(id<CLJIPersistentMap>)meta vector:(id<CLJIPersistentVector>)v start:(NSInteger)start end:(NSInteger)end {
	self = [super init];
	
	_meta = meta;
	if ([v isKindOfClass:CLJSubVector.class]) {
		CLJSubVector *sv = (CLJSubVector *)v;
		start += sv->_start;
		end += sv->_start;
		v = sv->_v;
	}
	_v = v;
	_start = start;
	_end = end;
	
	return self;
}

- (NSEnumerator *)objectEnumerator {
	//	return ((CLJPersistentVector *)_v).rangedIterator(_start, _end);
	return nil;
}

- (id)nth:(NSInteger)i {
	if ((_start + i >= _end) || (i < 0)) {
		@throw [NSException exceptionWithName:NSRangeException reason:@"" userInfo:nil];
	}
	return [_v nth:_start + i];
}

- (id<CLJIPersistentVector>)assocN:(NSInteger)i value:(id)val {
	if (_start + i > _end) {
		@throw [NSException exceptionWithName:NSRangeException reason:@"" userInfo:nil];
	} else if (_start + i == _end) {
		return (id<CLJIPersistentVector>)[self cons:val];
	}
	return [[CLJSubVector alloc] initWithMeta:_meta vector:[_v assocN:_start + i value:val] start:_start end:_end];
}

- (NSUInteger)count {
	return _end - _start;
}

- (id<CLJIPersistentVector>)cons:(id)o {
	return [[CLJSubVector alloc] initWithMeta:_meta vector:[_v assocN:_end value:o] start:_start end:_end + 1];
}

- (id<CLJIPersistentCollection>)empty {
	return (id<CLJIPersistentCollection>)[CLJPersistentVector.empty withMeta:self.meta];
}

- (id<CLJIPersistentStack>)pop {
	if (_end - 1 == _start) {
		return CLJPersistentVector.empty;
	}
	return [[CLJSubVector alloc]initWithMeta:_meta vector:_v start:_start end:_end - 1];
}

- (CLJSubVector *)withMeta:(id<CLJIPersistentMap>)meta{
	if (meta == _meta) {
		return self;
	}
	return [[CLJSubVector alloc] initWithMeta:meta vector:_v start:_start end:_end];
}

- (id<CLJIPersistentMap>)meta {
	return _meta;
}

@end
