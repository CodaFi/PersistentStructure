//
//  CLJUtils.m
//  PersistentStructure
//
//  Created by Robert Widmann on 12/29/13.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJUtils.h"
#import "CLJAbstractObject.h"
#import "CLJInterfaces.h"
#import "CLJAbstractSeq.h"
#import "CLJLazySeq.h"
#import "CLJStringSeq.h"
#import "CLJAbstractCons.h"
#import "CLJPersistentList.h"
#import "CLJReduced.h"
#import "CLJHashCollisionNode.h"
#import "CLJBitmapIndexedNode.h"
#import "CLJPersistentVector.h"
#import "CLJPersistentArrayMap.h"
#import "CLJSubVector.h"
#import "CLJMapEntry.h"
#import "CLJKeySeq.h"
#import "CLJValSeq.h"
#import "CLJBox.h"

@implementation CLJUtils

+ (id<CLJISeq>)seq:(id)coll {
	if ([coll isKindOfClass:CLJAbstractSeq.class]) {
		return (CLJAbstractSeq *)coll;
	} else if ([coll isKindOfClass:CLJLazySeq.class]) {
		return ((CLJLazySeq *)coll).seq;
	} else {
		return [CLJUtils seqFrom:coll];
	}
}

+ (id<CLJISeq>)seqFrom:(id)coll {
	if ([coll conformsToProtocol:@protocol(CLJISeqable)]) {
		return ((id<CLJISeqable>) coll).seq;
	} else if (coll == nil) {
		return nil;
//	else if (coll.getClass().isArray())
//		return ArraySeq.createFromObject(coll);
	} else if ([coll isKindOfClass:NSString.class]) {
		return [[CLJStringSeq alloc] initWithString:coll];
	} else {
		[NSException raise:NSInvalidArgumentException format:@"Dont know how to create an object conforming to CLJISeq from %@", [coll class]];
		return nil;
	}
}


+ (BOOL)isEqual:(id)k1 other:(id)k2 {
	if (k1 == k2) {
		return YES;
	}
	return k1 != nil && [k1 isEqual:k2];
}

+ (BOOL)equiv:(void *)k1 other:(void *)k2 {
	return k1 == k2;
}

+ (NSInteger)dohasheq:(id<CLJIHashEq>)o {
	return [o hasheq];
}

+ (CLJArray)seqToArray:(id<CLJISeq>)seq {
	NSInteger len = [CLJUtils length:seq];
	CLJArray ret = CLJArrayCreate(len);
	for (NSInteger i = 0; seq != nil; i++, seq = seq.next) {
		ret.array[i] = seq.first;
	}
	return ret;
}

+ (NSInteger)length:(id<CLJISeq>)list {
	NSInteger i = 0;
	for (id<CLJISeq> c = list; c != nil; c = c.next) {
		i++;
	}
	return i;
}

+ (NSInteger)count:(id)o {
	if ([o conformsToProtocol:@protocol(CLJICounted)]) {
		return ((id<CLJICounted>) o).count;
	}
	return [CLJUtils countFrom:[CLJUtils ret1o:o null:nil]];
}

+ (NSInteger)countFrom:(id)o {
	if (o == nil) {
		return 0;
	} else if ([o conformsToProtocol:@protocol(CLJIPersistentCollection) ]) {
		id<CLJISeq> s = [CLJUtils seq:o];
		o = nil;
		NSInteger i = 0;
		for (; s != nil; s = s.next) {
			if ([s conformsToProtocol:@protocol(CLJICounted)])
				return i + s.count;
			i++;
		}
		return i;
	} else if ([o respondsToSelector:@selector(length)]) {
		return [o length];
	}
//	else if (o instanceof Collection)
//		return ((Collection) o).size();
//	else if (o instanceof Map)
//		return ((Map) o).size();
	else if ([o respondsToSelector:@selector(count)]) {
		return [o count];
	}
	
	CLJRequestConcreteImplementation(o, @selector(count), [o class]);
	return -1;
}

+ (BOOL)containsObject:(id)coll key:(id)key {
	if (coll == nil) {
		return NO;
	} else if ([coll conformsToProtocol:@protocol(CLJIAssociative)]) {
		return [((id<CLJIAssociative>) coll) containsKey:key];
	} else if ([coll conformsToProtocol:@protocol(CLJIPersistentSet)]) {
		return [((id<CLJIPersistentSet>) coll) containsObject:key];
	} else if ([coll conformsToProtocol:@protocol(CLJIMap)]) {
		id<CLJIMap> m = (id<CLJIMap>) coll;
		return [m containsKey:key];
	} else if ([coll conformsToProtocol:@protocol(CLJISet)]) {
		id<CLJISet> s = (id<CLJISet>) coll;
		return [s containsObject:key];
	}
//	else if (key instanceof Number && (coll instanceof String || coll.getClass().isArray())) {
//		int n = ((Number) key).intValue();
//		return n >= 0 && n < count(coll);
//	}
	[NSException raise:NSInvalidArgumentException format:@"CLJContains not supported on collection %@", [coll class]];
	return NO;
}

+ (id)nthOf:(id)coll index:(NSInteger)n {
	if ([coll conformsToProtocol:@protocol(CLJIIndexed)]) {
		return [((id<CLJIIndexed>)coll) objectAtIndex:n];
	}
	return [CLJUtils nthFrom:[CLJUtils ret1s:coll null:nil] index:n];
}

+ (id)nthOf:(id)coll index:(NSInteger)n notFound:(id)notFound {
	if([coll conformsToProtocol:@protocol(CLJIIndexed)]) {
		id<CLJIIndexed> v = (id<CLJIIndexed>)coll;
		return [v objectAtIndex:n default:notFound];
	}
	return [CLJUtils nthFrom:coll index:n notFound:notFound];
}

+ (id)nthFrom:(id)coll index:(NSInteger)n {
	if (coll == nil) {
		return nil;
	} else if ([coll isKindOfClass:NSString.class]) {
		return @([coll characterAtIndex:n]);
	} else if ([coll respondsToSelector:@selector(objectAtIndexedSubscript:)]) {
		return [coll objectAtIndexedSubscript:n];
	} else if ([coll isKindOfClass:CLJMapEntry.class]) {
		CLJMapEntry *e = (CLJMapEntry *) coll;
		if (n == 0) {
			return e.key;
		} else if (n == 1) {
			return e.val;
		}
		[NSException raise:NSRangeException format:@"Range or index out of bounds"];
	} else if ([coll conformsToProtocol:@protocol(CLJISequential)]) {
		id<CLJISeq> seq = [CLJUtils seq:coll];
		coll = nil;
		for (NSInteger i = 0; i <= n && seq != nil; i++, seq = seq.next) {
			if (i == n)
				return seq.first;
		}
		[NSException raise:NSRangeException format:@"Range or index out of bounds"];
	} else {
		CLJRequestConcreteImplementation(coll, @selector(nthFrom:index:), [coll class]);
	}
	return nil;
}

+ (id)nthFrom:(id)coll index:(NSInteger)n notFound:(id)notFound {
	if(coll == nil) {
		return notFound;
	} else if(n < 0) {
		return notFound;
	} else if([coll conformsToProtocol:@protocol(CLJIMapEntry)]) {
		id<CLJIMapEntry> e = (id<CLJIMapEntry>)coll;
		if(n == 0) {
			return e.key;
		} else if(n == 1) {
			return e.val;
		}
		return notFound;
	} else if([coll conformsToProtocol:@protocol(CLJISequential)]) {
		id<CLJISeq> seq = [CLJUtils seq:coll];
		coll = nil;
		for(int i = 0; i <= n && seq != nil; i++, seq = seq.next) {
			if(i == n) {
				return seq.first;
			}
		}
		return notFound;
	} else {
		CLJRequestConcreteImplementation(coll, @selector(nthFrom:index:), [coll class]);
	}
	return nil;
}

+ (id<CLJISeq>)cons:(id)x to:(id)coll {
	if (coll == nil) {
		return [[CLJPersistentList alloc] initWithFirstObject:x];
	} else if ([coll conformsToProtocol:@protocol(CLJISeq)]) {
		return [[CLJAbstractCons alloc] initWithFirst:x rest:coll];
	} else {
		return [[CLJAbstractCons alloc] initWithFirst:x rest:[CLJUtils seq:coll]];
	}
}

+ (id<CLJIPersistentCollection>)conj:(id)x to:(id<CLJIPersistentCollection>)coll {
	if (coll == nil) {
		return [[CLJPersistentList alloc] initWithFirstObject:x];
	}
	return [coll cons:x];
}

+ (id<CLJIPersistentVector>)subvecOf:(id<CLJIPersistentVector>)v start:(NSInteger)start end:(NSInteger)end {
	if (end < start || start < 0 || end > v.count) {
		[NSException raise:NSRangeException format:@"Range or index out of bounds"];
	}
	if (start == end) {
		return CLJPersistentVector.empty;
	}
	return [[CLJSubVector alloc] initWithMeta:nil vector:v start:start end:end];
}

+ (id<CLJIAssociative>)associateKey:(id)key to:(id)val in:(id)coll {
	if (coll == nil) {
		__strong id arr[2] = {key, val};
		return [[CLJPersistentArrayMap alloc] initWithArray:(CLJArray) {
			.array = arr,
			.length = 2,
		}];
	}
	return [((id<CLJIAssociative>) coll) associateKey:key withValue:val];
}

+ (id)first:(id)x {
	if ([x conformsToProtocol:@protocol(CLJISeq)]) {
		return ((id<CLJISeq>) x).first;
	}
	id<CLJISeq> seq = [CLJUtils seq:x];
	if (seq == nil) {
		return nil;
	}
	return seq.first;
}

+ (id)second:(id)x {
	return [CLJUtils first:[CLJUtils next:x]];
}

+ (id)third:(id)x {
	return [CLJUtils first:[CLJUtils next:[CLJUtils next:x]]];
}

+ (id)fourth:(id)x {
	return [CLJUtils first:[CLJUtils next:[CLJUtils next:[CLJUtils next:x]]]];
}

+ (id<CLJISeq>)next:(id)x {
	if ([x conformsToProtocol:@protocol(CLJISeq)]) {
		return ((id<CLJISeq>)x).next;
	}
	id<CLJISeq> seq = [CLJUtils seq:x];
	if (seq == nil) {
		return nil;
	}
	return seq.next;
}

+ (id<CLJISeq>)more:(id)x {
	if ([x conformsToProtocol:@protocol(CLJISeq)]) {
		return ((id<CLJISeq>)x).more;
	}
	id<CLJISeq> seq = [CLJUtils seq:x];
	if (seq == nil) {
		return nil;
	}
	return seq.more;
}

+ (id)ret1o:(id)ret null:(id)null {
	return ret;
}

+ (id<CLJISeq>)ret1s:(id<CLJISeq>)ret null:(id)null {
	return ret;
}

+ (BOOL)isReduced:(id)x {
	return [x isKindOfClass:CLJReduced.class];
}

+ (BOOL)isInteger:(id)obj {
	return [obj isKindOfClass:NSNumber.class]
	|| [obj isKindOfClass:NSString.class]
	|| [obj isKindOfClass:NSValue.class];
}

+ (NSUInteger)hash:(id)obj {
	return obj != nil ? [obj hash] : 0;
}

+ (NSInteger)hasheq:(id)o {
	if (o == nil) {
		return 0;
	}
	if ([o conformsToProtocol:@protocol(CLJIHashEq)]) {
		return [CLJUtils dohasheq:(id<CLJIHashEq>)0];
	}
//	if (o instanceof Number)
//		return Numbers.hasheq((Number)o);
	return [o hash];
}

+ (CLJArray)_emptyArray {
	return CLJArrayCreate(0);
}

+ (NSInteger)bitCount:(NSUInteger)i {
	i = i - ((i >> 1) & 0x55555555);
	i = (i & 0x33333333) + ((i >> 2) & 0x33333333);
	return (((i + (i >> 4)) & 0x0F0F0F0F) * 0x01010101) >> 24;
}

+ (NSInteger)bitPos:(NSInteger)hash shift:(NSInteger)shift {
	return 1 << [CLJUtils mask:hash shift:shift];
}

+ (NSInteger)mask:(NSInteger)x shift:(NSInteger)n {
	NSInteger mask = ~(-1 << n) << (32 - n);
	return  ~mask & ( (x >> n) | mask) & 0x01f;
}

+ (CLJArray /*id<CLJINode>[]*/)cloneAndSetNode:(CLJArray)array index:(NSInteger)i node:(id<CLJINode>)a {
	CLJArray clone = CLJArrayCreateCopy(array);
	clone.array[i] = a;
	return clone;
}

+ (CLJArray /*id<CLJINode>[]*/)cloneAndSetObject:(CLJArray)array index:(NSInteger)i node:(id)a {
	CLJArray clone = CLJArrayCreateCopy(array);
	clone.array[i] = a;
	return clone;
}

+ (CLJArray)cloneAndSet:(CLJArray)array index:(NSInteger)i withObject:(id)a index:(NSInteger)j withObject:(id)b {
	CLJArray clone = CLJArrayCreateCopy(array);
	clone.array[i] = a;
	clone.array[j] = b;
	return clone;
}

+ (CLJArray)removePair:(CLJArray)array index:(NSInteger)i {
	CLJArray newArray = CLJArrayCreate(array.length - 2);
	CLJArrayCopy(array, 0, newArray, 0, 2 * i);
	CLJArrayCopy(array, 2 * (i+1), newArray, 2 * i, newArray.length - 2 * i);
	return newArray;
}

+ (id<CLJINode>)createNodeWithShift:(NSInteger)shift key:(id)key1 value:(id)val1 hash:(NSInteger)key2hash key:(id)key2 value:(id)val2 {
	NSInteger key1hash = [self hash:key1];
	if (key1hash == key2hash) {
		return [[CLJHashCollisionNode alloc] initWithThread:nil hash:key1hash count:2 array:(CLJArray){
			//{key1, val1, key2, val2})
		}];
	}
	CLJBox *addedLeaf = [CLJBox boxWithVal:nil];
	NSThread *edit = NSThread.currentThread;
	return [[CLJBitmapIndexedNode.empty assocOnThread:edit shift:shift hash:key1hash key:key1 val:val1 addedLeaf:addedLeaf] assocOnThread:edit shift:shift hash:key2hash key:key2 val:val2 addedLeaf:addedLeaf];
}

+ (id<CLJINode>)createNodeOnThread:(NSThread *)edit shift:(NSInteger)shift key:(id)key1 value:(id)val1 hash:(NSInteger)key2hash key:(id)key2 value:(id)val2 {
	NSInteger key1hash = [self hash:key1];
	if (key1hash == key2hash) {
		__strong id arr[] = { key1, val1, key2, val2 };
		return [[CLJHashCollisionNode alloc] initWithThread:nil hash:key1hash count:2 array:(CLJArray){
			.array = arr,
			.length = 4,
		}];
	}
	CLJBox *addedLeaf = [CLJBox boxWithVal:nil];
	return [[CLJBitmapIndexedNode.empty assocOnThread:edit shift:shift hash:key1hash key:key1 val:val1 addedLeaf:addedLeaf] assocOnThread:edit shift:shift hash:key2hash key:key2 val:val2 addedLeaf:addedLeaf];
}

+ (NSComparisonResult)compare:(id)k1 to:(id)k2 {
	if (k1 == k2) {
		return 0;
	}
	if (k1 != nil) {
		if (k2 == nil) {
			return 1;
		}
		if ([k1 respondsToSelector:@selector(compare:)]) {
			return [k1 compare:k2];
		}
		return [((id<CLJIComparable>) k1) compareTo:k2];
	}
	return -1;
}

+ (id<CLJISeq>)keys:(id)coll {
	return [CLJKeySeq create:[CLJUtils seq:coll]];
}

+ (id<CLJISeq>)vals:(id)coll {
	return [CLJValSeq create:[CLJUtils seq:coll]];
}

+ (id<CLJISeq>)list:(id)arg1 {
	return [[CLJPersistentList alloc] initWithFirstObject:arg1];
}

@end
