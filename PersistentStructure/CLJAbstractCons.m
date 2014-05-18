//
//  _CLJCons.m
//  PersistentStructure
//
//  Created by Robert Widmann on 12/30/13.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJAbstractCons.h"
#import "CLJISeq.h"
#import "CLJISeqable.h"
#import "CLJIPersistentCollection.h"
#import "CLJIPersistentMap.h"
#import "CLJPersistentList.h"
#import "CLJUtils.h"

@implementation CLJAbstractCons {
	id _first;
	id<CLJISeq> _more;
}

- (id)initWithFirst:(id)first rest:(id<CLJISeq>)more {
	self = [super init];
	
	_first = first;
	_more = more;
	
	return self;
}

- (id)initWithMeta:(id<CLJIPersistentMap>)meta first:(id)first rest:(id<CLJISeq>)more {
	self = [super initWithMeta:meta];
	
	_first = first;
	_more = more;
	
	return self;
}

- (id)first {
	return _first;
}

- (id<CLJISeq>)next {
	return _more.seq;
}

- (id<CLJISeq>)more {
	if (_more == nil) {
		return (id<CLJISeq>)CLJPersistentList.empty;
	}
	return _more;
}

- (NSUInteger)count {
	return 1 + [CLJUtils count:_more];
}

- (CLJAbstractCons *)withMeta:(id<CLJIPersistentMap>)meta {
	return [[CLJAbstractCons alloc] initWithMeta:meta first:_first rest:_more];
}

@end
