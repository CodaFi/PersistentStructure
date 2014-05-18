//
//  CLJReduced.m
//  PersistentStructure
//
//  Created by Robert Widmann on 12/31/13.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJReduced.h"

@implementation CLJReduced {
	id _val;
}

- (id)initWithVal:(id)val {
	self = [super init];
	
	_val = val;
	
	return self;
}

- (id)deref {
	return _val;
}

@end
