//
//  CLJMapEntry.m
//  PersistentStructure
//
//  Created by Robert Widmann on 12/30/13.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJMapEntry.h"

@implementation CLJMapEntry {
	id _key;
	id _val;
}

- (id)initWithKey:(id)key val:(id)val {
	self = [super init];
	
	_key = key;
	_val = val;
	
	return self;
}

- (id)key {
	return _key;
}

- (id)val {
	return _val;
}

- (id)getKey {
	return self.key;
}

- (id)getValue {
	return self.val;
}

@end
