//
//  CLJNode.m
//  PersistentStructure
//
//  Created by Robert Widmann on 3/26/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJNode.h"

@implementation CLJNode

- (id)initWithThread:(NSThread *)edit {
	self = [super init];
	
	_edit = edit;
	_array = CLJArrayCreate(32);
	
	return self;
}

- (id)initWithThread:(NSThread *)edit array:(CLJArray)array {
	self = [super init];
	
	_edit = edit;
	_array = array;
	
	return self;
}

@end
