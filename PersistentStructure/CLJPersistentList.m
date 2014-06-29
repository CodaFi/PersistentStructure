//
//  CLJIPersistentList.m
//  PersistentStructure
//
//  Created by Robert Widmann on 12/30/13.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJPersistentList.h"
#import "CLJAbstractObject.h"
#import "CLJICollection.h"
#import "CLJIPersistentMap.h"
#import "CLJIPersistentList.h"
#import "CLJIList.h"
#import "CLJUtils.h"

@interface CLJEmptyList : NSObject <CLJIPersistentList, CLJIList, CLJISeq, CLJICounted>
- (instancetype)initWithMeta:(id<CLJIPersistentMap>)meta;
- (CLJEmptyList *)withMeta:(id<CLJIPersistentMap>)meta;
@end

static CLJEmptyList *_CLJSingletonEmptyList = nil;

@implementation CLJPersistentList {
	id _first;
	id <CLJIPersistentList> _rest;
	NSInteger _count;
}

+ (void)load {
	if (self.class != CLJPersistentList.class) {
		return;
	}
	_CLJSingletonEmptyList = [[CLJEmptyList alloc] initWithMeta:nil];
}

+ (id<CLJIPersistentCollection>)empty {
	return _CLJSingletonEmptyList;
}

- (id)initWithFirstObject:(id)first {
	self = [super init];
	
	_first = first;
	_rest = nil;
	_count = 1;
	
	return self;
}

- (id)initWithMeta:(id<CLJIPersistentMap>)meta first:(id)first rest:(id<CLJIPersistentList>)rest count:(NSInteger)count {
	self = [super initWithMeta:meta];
	
	_first = first;
	_rest = rest;
	_count = count;
	
	return self;
}

+ (id<CLJIPersistentList>)create:(id<CLJIList>)init {
	id <CLJIPersistentList> ret = (id <CLJIPersistentList>)CLJPersistentList.empty;
	NSEnumerator *it = [init objectEnumerator];
	id obj = nil;
	while ((obj = it.nextObject) != nil) {
		ret = (id<CLJIPersistentList>)[ret cons:obj];
	}
	return ret;
}

- (id)first {
	return _first;
}

- (id<CLJISeq>)next {
	if (_count == 1) {
		return nil;
	}
	return (id<CLJISeq>) _rest;
}

- (id)peek {
	return self.first;
}

- (id<CLJIPersistentList>)pop {
	if (_rest == nil) {
		return [_CLJSingletonEmptyList withMeta:_meta];
	}
	return _rest;
}

- (NSUInteger)count {
	return _count;
}

- (CLJPersistentList *)cons:(id)o {
	return [[CLJPersistentList alloc] initWithMeta:_meta first:o rest:self count:_count + 1];
}

- (id<CLJIPersistentCollection>)empty{
	return [_CLJSingletonEmptyList withMeta:_meta];
}

- (CLJPersistentList *)withMeta:(id<CLJIPersistentMap>)meta {
	if (meta != _meta) {
		return [[CLJPersistentList alloc] initWithMeta:_meta first:_first rest:_rest count:_count];
	}
	return self;
}

- (id)reduce:(CLJIReduceBlock)f {
	id ret = self.first;
	for (id<CLJISeq> s = self.next; s != nil; s = s.next) {
		ret = f(ret, s.first);
	}
	return ret;
}

- (id)reduce:(CLJIReduceBlock)f start:(id)start {
	id ret = f(start, self.first);
	for (id<CLJISeq> s = self.next; s != nil; s = s.next) {
		ret = f(ret, s.first);
	}
	return ret;
}


@end

@implementation CLJEmptyList {
	id<CLJIPersistentMap> _meta;
}

- (NSUInteger)hash {
	return 1;
}

- (BOOL)isEqual:(id)o {
	return ([o conformsToProtocol:@protocol(CLJISequential) ] || [o conformsToProtocol:@protocol(CLJIList)]) && [CLJUtils seq:o] == nil;
}

- (BOOL)equiv:(id)o {
	return [self isEqual:o];
}

- (instancetype)initWithMeta:(id<CLJIPersistentMap>)meta {
	self = [super init];
	
	_meta = meta;
	
	return self;
}

- (id)first {
	return nil;
}

- (id<CLJISeq>)next {
	return nil;
}

- (id<CLJISeq>)more {
	return self;
}

- (CLJPersistentList *)cons:(id)o {
	return [[CLJPersistentList alloc] initWithMeta:_meta first:o rest:nil count:1];
}

- (id<CLJIPersistentCollection>)empty {
	return self;
}

- (CLJEmptyList *)withMeta:(id<CLJIPersistentMap>)meta {
	if (meta != _meta) {
		return [[CLJEmptyList alloc] initWithMeta:meta];
	}
	return self;
}

- (id)peek {
	return nil;
}

- (id<CLJIPersistentList>)pop {
	NSAssert(0, @"Can't pop empty list");
	return nil;
}

- (NSUInteger)count {
	return 0;
}

- (id<CLJISeq>)seq {
	return nil;
}

- (BOOL)isEmpty {
	return YES;
}

- (BOOL)containsObject:(id)o {
	return NO;
}

- (NSEnumerator *)objectEnumerator {
//	return new Iterator(){
//		
//		public boolean hasNext(){
//			return false;
//		}
//		
//		public Object next(){
//			throw new NoSuchElementException();
//		}
//		
//		public void remove(){
//			throw new UnsupportedOperationException();
//		}
//	};
	return NSEnumerator.new;
}

- (CLJArray)toArray {
	return [CLJUtils _emptyArray];
}

//////////// List stuff /////////////////
- (id<CLJIList>)reify {
//	return Collections.unmodifiableList(@[self]);
	return nil;
}

- (id<CLJIList>)subListFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
	return [self.reify subListFromIndex:fromIndex toIndex:toIndex];
}

- (id)set:(NSInteger)index element:(id)element {
	CLJRequestConcreteImplementation(self, _cmd, Nil);
	return nil;
}

- (NSInteger)indexOf:(id)o {
	id<CLJISeq> s = self.seq;
	for (NSInteger i = 0; s != nil; s = s.next, i++) {
		if ([CLJUtils equiv:(__bridge void *)(s.first) other:(__bridge void *)(o)]) {
			return i;
		}
	}
	return NSNotFound;
}

- (NSInteger)lastIndexOf:(id)o {
	return [self.reify lastIndexOf:o];
}

- (id)get:(NSInteger)index {
	return [CLJUtils nthOf:self index:index];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id [])buffer count:(NSUInteger)len {
	return 0;
}

@end

