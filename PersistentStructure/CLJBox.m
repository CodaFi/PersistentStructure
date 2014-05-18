//
//  CLJBox.m
//  PersistentStructure
//
//  Created by Robert Widmann on 12/30/13.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJBox.h"

@implementation CLJBox

+ (instancetype)boxWithVal:(id)val {
	CLJBox *box = [[self alloc]init];
	box->_val = val;
	return box;
}

- (void)setVal:(id)val {
	_val = val;
}

- (id)val {
	return _val;
}

@end
