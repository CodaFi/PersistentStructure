//
//  CLJSeqIterator.m
//  PersistentStructure
//
//  Created by Robert Widmann on 3/26/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJSeqIterator.h"
#import "CLJUtils.h"

@implementation CLJSeqIterator {
	id<CLJISeq> _seq;
}

- (id)initWithSeq:(id<CLJISeq>)seq {
	self = [super init];
	
	_seq = seq;
	
	return self;
}

- (id)nextObject {
	if (_seq == nil) {
		[NSException raise:NSInternalInconsistencyException format:@"Cannot request next object of empty seq."];
	}
	id ret = [CLJUtils first:_seq];
	_seq = [CLJUtils next:_seq];
	return ret;
}

@end
