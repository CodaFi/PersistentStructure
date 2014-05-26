//
//  _CLJPersistentMap.m
//  PersistentStructure
//
//  Created by Robert Widmann on 12/29/13.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJAbstractPersistentMap.h"
#import "CLJAbstractObject.h"
#import "CLJInterfaces.h"
#import "CLJAbstractSeq.h"
#import "CLJKeySeq.h"
#import "CLJValSeq.h"
#import "CLJUtils.h"

@implementation CLJAbstractPersistentMap {
	NSInteger _hash;
	NSInteger _hasheq;
}

- (id)init {
	self = [super init];
	_hash = -1;
	_hasheq = -1;
	return self;
}

- (id<CLJIPersistentCollection>)cons:(id)o {
	if ([o conformsToProtocol:@protocol(CLJIMapEntry)]) {
		id<CLJIMapEntry>e = (id<CLJIMapEntry>)o;
		return [self associateKey:e.key value:e.val];
	} else if ([o conformsToProtocol:@protocol(CLJIPersistentVector)]) {
		id<CLJIPersistentVector> v = (id<CLJIPersistentVector>) o;
		if (v.count != 2) {
			NSAssert(0, @"Vector arg to map conj must be a pair");
		}
		return [self associateKey:[v objectAtIndex:0] value:[v objectAtIndex:1]];
	}
	id<CLJIPersistentMap> ret = self;
	for (id<CLJISeq> es = [CLJUtils seq:o]; es != nil; es = es.next) {
		id<CLJIMapEntry> e = (id<CLJIMapEntry>)es.first;
		ret = [ret associateKey:e.key value:e.val];
	}
	return ret;
}

- (BOOL)isEqual:(id)obj {
	return [CLJAbstractPersistentMap mapisEqual:self other:obj];
}

+ (BOOL)mapisEqual:(id<CLJIPersistentMap>)m1 other:(id)obj {
	if (m1 == obj) return YES;
	if (![obj conformsToProtocol:@protocol(CLJIMap)]) {
		return NO;
	}
	id<CLJIMap> m = (id<CLJIMap>) obj;
	
	if (m.count != m1.count) {
		return NO;
	}
	
	for (id<CLJISeq> s = m1.seq; s != nil; s = s.next) {
		id<CLJIMapEntry> e = (id<CLJIMapEntry>)s.first;
		BOOL found = [m containsKey:e.key];
		
		if (!found || ![CLJUtils isEqual:e.val other:[m objectForKey:e.key]]) {
			return NO;
		}
	}
	
	return YES;
}

- (BOOL)equiv:(id)obj {
	if (![obj conformsToProtocol:@protocol(CLJIMap)]) {
		return NO;
	}
	if (![obj conformsToProtocol:@protocol(CLJIPersistentMap)] && ![obj conformsToProtocol:@protocol(CLJIMapEquivalence)]) {
		return NO;
	}
	
	id<CLJIMap> m = (id<CLJIMap>) obj;
	
	if (m.count != self.count) {
		return NO;
	}
	
	for (id<CLJISeq> s = self.seq; s != nil; s = s.next) {
		id<CLJIMapEntry> e = (id<CLJIMapEntry>)s.first;
		BOOL found = [m containsKey:e.key];
		
		if (!found || ![CLJUtils equiv:(__bridge void *)(e.val) other:(__bridge void *)([m objectForKey:e.key])]) {
			return NO;
		}
	}
	
	return true;
}

- (NSUInteger)hash {
	if (_hash == -1) {
		_hash = [CLJAbstractPersistentMap mapHash:self];
	}
	return _hash;
}

+ (NSUInteger)mapHash:(id<CLJIPersistentMap>)m {
	NSInteger hash = 0;
	for (id<CLJISeq> s = m.seq; s != nil; s = s.next) {
		id<CLJIMapEntry> e = (id<CLJIMapEntry>)s.first;
		hash += (e.key == nil ? 0 : [e.key hash]) ^ (e.val == nil ? 0 : [e.val hash]);
	}
	return hash;
}

- (NSInteger)hasheq {
	if (_hasheq == -1) {
		_hasheq = [CLJAbstractPersistentMap mapHasheq:self];
	}
	return _hasheq;
}

+ (NSInteger)mapHasheq:(id<CLJIPersistentMap>)m {
	NSInteger hash = 0;
	for (id<CLJISeq> s = m.seq; s != nil; s = s.next) {
		id<CLJIMapEntry> e = (id<CLJIMapEntry>)s.first;
		hash += [CLJUtils hasheq:e.key] ^ [CLJUtils hasheq:e.val];
	}
	return hash;
}

// java.util.Map implementation

- (BOOL)containsValue:(id)value {
	return [self.values containsObject:value];
}

- (id<CLJISet>)allEntries {
//	return new AbstractSet(){
//		
//		public Iterator iterator(){
//			return APersistentMap.this.iterator();
//		}
//		
//		public NSInteger size(){
//			return count();
//		}
//		
//		public NSInteger hashCode(){
//			return APersistentMap.this.hashCode();
//		}
//		
//		public boolean contains(Object o){
//			if (o instanceof Entry)
//			{
//				Entry e = (Entry) o;
//				Entry found = entryForKey(e.key());
//				if (found != null && Util.equals(found.val(), e.val()))
//					return true;
//			}
//			return false;
//		}
//	};
	return nil;
}

- (BOOL)isEmpty {
	return self.count == 0;
}

- (id<CLJISet>)allKeys {
//	return new AbstractSet(){
//		
//		public Iterator iterator(){
//			final Iterator mi = APersistentMap.this.iterator();
//			
//			return new Iterator(){
//				
//				
//				public boolean hasNext(){
//					return mi.hasNext();
//				}
//				
//				public Object next(){
//					Entry e = (Entry) mi.next();
//					return e.key();
//				}
//				
//				public void remove(){
//					throw new UnsupportedOperationException();
//				}
//			};
//		}
//		
//		public NSInteger size(){
//			return count();
//		}
//		
//		public boolean contains(Object o){
//			return APersistentMap.this.containsKey(o);
//		}
//	};
	return nil;
}

- (id)setObject:(id)val forKey:(id)key; {
	CLJRequestConcreteImplementation(self, _cmd, Nil);
	return nil;
}

- (NSUInteger)count {
	return self.count;
}

- (id<CLJICollection>)values {
//	return new AbstractCollection(){
//		
//		public Iterator iterator(){
//			final Iterator mi = APersistentMap.this.iterator();
//			
//			return new Iterator(){
//				
//				
//				public boolean hasNext(){
//					return mi.hasNext();
//				}
//				
//				public Object next(){
//					Entry e = (Entry) mi.next();
//					return e.val();
//				}
//				
//				public void remove(){
//					throw new UnsupportedOperationException();
//				}
//			};
//		}
//		
//		public NSInteger size(){
//			return count();
//		}
//	};
	return nil;
}

#pragma mark - Abtract

- (id<CLJIMapEntry>)entryForKey:(id)key {
	return nil;
}

- (id)objectForKey:(id)key {
	return nil;
}

- (id)objectForKey:(id)key default:(id)notFound {
	return nil;
}

- (id<CLJIPersistentMap>)without:(id)key {
	return nil;
}

- (id<CLJIPersistentMap>)associateKey:(id)key value:(id)val {
	return nil;
}

- (id<CLJIPersistentMap>)assocEx:(id)key value:(id)val {
	return nil;
}

- (id<CLJIAssociative>)associateKey:(id)key withValue:(id)val {
	return nil;
}

- (id<CLJIPersistentCollection>)empty {
	return nil;
}

- (id<CLJISeq>)seq {
	return nil;
}

- (BOOL)containsKey:(id)key {
	return NO;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id [])buffer count:(NSUInteger)len {
	return 0;
}

@end
