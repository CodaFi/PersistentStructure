//
//  CLJObj.m
//  PersistentStructure
//
//  Created by IDA WIDMANN on 6/24/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//

#import "CLJObj.h"
#import "CLJAbstractObject.h"

@implementation CLJObj {
	id<CLJIPersistentMap> _meta;
}

- (id)initWithMeta:(id<CLJIPersistentMap>)meta {
	self = [super init];
	
	_meta = meta;
	
	return self;
}

- (id<CLJIPersistentMap>)meta {
	return _meta;
}

- (id<CLJIObj>)withMeta:(id<CLJIPersistentMap>)meta {
	CLJRequestConcreteImplementation(self, _cmd, CLJObj.class);
	return nil;
}

@end
