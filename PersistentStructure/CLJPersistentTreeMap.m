//
//  CLJPersistentTreeMap.m
//  PersistentStructure
//
//  Created by Robert Widmann on 5/25/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//

#import "CLJPersistentTreeMap.h"
#import "CLJTreeNode.h"
#import "CLJSortedTreeSeq.h"
#import "CLJMapEntry.h"
#import "CLJNode.h"
#import "CLJBox.h"
#import "CLJSeq.h"
#import "CLJUtils.h"

@implementation CLJPersistentTreeMap {
	CLJComparatorBlock _comp;
	CLJTreeNode *_tree;
	NSInteger _count;
	id<CLJIPersistentMap> _meta;
}

static CLJPersistentTreeMap *EMPTY;

+ (id<CLJIPersistentMap>)create:(id<CLJIMap>)other {
	id<CLJIPersistentMap> ret = (id<CLJIPersistentMap>)EMPTY;
	for (id o in other.allEntries) {
		CLJMapEntry *e = (CLJMapEntry *) o;
		ret = [ret associateKey:e.key value:e.val];
	}
	return ret;
}

//public PersistentTreeMap(){
//	this(RT.DEFAULT_COMPARATOR);
//}

- (id<CLJIObj>)withMeta:(id<CLJIPersistentMap>)meta {
	return [[CLJPersistentTreeMap alloc] initWithMeta:meta comparator:_comp tree:_tree count:_count];
}

- (id)initWithComparator:(CLJComparatorBlock)comparator {
	return [self initWithMeta:nil comparator:comparator];
}


- (id)initWithMeta:(id<CLJIPersistentMap>)meta comparator:(CLJComparatorBlock)comp {
	self = [super init];
	
	_comp = comp;
	_meta = meta;
	_tree = nil;
	_count = 0;
	
	return self;
}


- (id)initWithMeta:(id<CLJIPersistentMap>)meta comparator:(CLJComparatorBlock)comp tree:(CLJTreeNode *)tree count:(NSInteger)count {
	self = [super init];

	_meta = meta;
	_comp = comp;
	_tree = tree;
	_count = count;
	
	return self;
}

- (id)initWithComparator:(CLJComparatorBlock)comp tree:(CLJTreeNode *)tree count:(NSInteger)count meta:(id<CLJIPersistentMap>)meta {
	self = [super init];
	
	_meta = meta;
	_comp = comp;
	_tree = tree;
	_count = count;
	
	return self;
}

+ (id)createWithSeq:(id<CLJISeq>)items {
	id<CLJIPersistentMap> ret = EMPTY;
	for(; items != nil; items = items.next.next) {
		if(items.next == nil) {
			NSAssert(0, @"No value supplied for key: %@", items.first);
		}
		ret = [ret associateKey:items.first value:[CLJUtils second:items]];
	}
	return (CLJPersistentTreeMap *)ret;
}

+ (id)createWithComparator:(CLJComparatorBlock)comp seq:(id<CLJISeq>)items {
	id<CLJIPersistentMap> ret = [[CLJPersistentTreeMap alloc] initWithComparator:comp];
	for(; items != nil; items = items.next.next) {
		if(items.next == nil) {
			NSAssert(0, @"No value supplied for key: %@", items.first);
		}
		ret = [ret associateKey:items.first value:[CLJUtils second:items]];
	}
	return (CLJPersistentTreeMap *)ret;
}

- (BOOL)containsKey:(id)key {
	return [self objectForKey:key] != nil;
}

- (id<CLJIPersistentMap>)assocEx:(id)key value:(id)val {
	CLJBox *found = [CLJBox boxWithVal:nil];
	CLJTreeNode *t = [self add:_tree key:key val:val found:found];
	if(t == nil) {  //nil == already contains key
		NSAssert(0, @"Key already present");
	}
	return [[CLJPersistentTreeMap alloc] initWithMeta:self.meta comparator:_comp tree:t.blacken count:_count + 1];
}

- (id<CLJIPersistentMap>)associateKey:(id)key value:(id)val {
	CLJBox *found = [CLJBox boxWithVal:nil];
	CLJTreeNode *t = [self add:_tree key:key val:val found:found];
	if(t == nil) {  //nil == already contains key
		CLJTreeNode *foundNode = (CLJTreeNode *) found.val;
		if(foundNode.val == val)  //note only get same collection on identity of val, not equals()
			return self;
		return [[CLJPersistentTreeMap alloc] initWithMeta:self.meta comparator:_comp tree:[self replace:_tree key:key val:val] count:_count + 1];
	}
	return [[CLJPersistentTreeMap alloc] initWithMeta:self.meta comparator:_comp tree:t.blacken count:_count + 1];
}


- (id<CLJIPersistentMap>)without:(id)key {
	CLJBox *found = [CLJBox boxWithVal:nil];
	CLJTreeNode *t = [self remove:_tree key:key found:found];
	if(t == nil) {
		if(found.val == nil) { //nil == doesn't contain key
			return self;
		}
		//empty
		return [[CLJPersistentTreeMap alloc] initWithMeta:self.meta comparator:_comp];
	}
	return [[CLJPersistentTreeMap alloc] initWithMeta:self.meta comparator:_comp tree:t.blacken count:_count - 1];
}

- (id<CLJISeq>)seq {
	if(_count > 0) {
		return [CLJSortedTreeSeq createWithRoot:_tree ascending:true count:_count];
	}
	return nil;
}

- (id<CLJIPersistentCollection>)empty {
	return [[CLJPersistentTreeMap alloc] initWithMeta:self.meta comparator:_comp];
}

- (id<CLJISeq>)reversedSeq {
	if(_count > 0) {
		return [CLJSortedTreeSeq createWithRoot:_tree ascending:false count:_count];
	}
	return nil;
}

- (CLJComparatorBlock)comparator {
	return _comp;
}

- (id)entryKey:(id)entry {
	return ((id<CLJIMapEntry>)entry).key;
}

- (id<CLJISeq>)seq:(BOOL)ascending {
	if(_count > 0) {
		return [CLJSortedTreeSeq createWithRoot:_tree ascending:ascending count:_count];
	}
	return nil;
}

- (id<CLJISeq>)seqFrom:(id)key ascending:(BOOL)ascending {
	if(_count > 0) {
		id<CLJISeq> stack = nil;
		CLJTreeNode *t = _tree;
		while(t != nil) {
			int c = [self doCompare:key :t.key];
			if(c == 0) {
				stack = [CLJUtils cons:t to:stack];
				return [[CLJSortedTreeSeq alloc] initWithStack:stack ascending:ascending];
			} else if(ascending) {
				if(c < 0) {
					stack = [CLJUtils cons:t to:stack];
					t = t.left;
				}
				else
					t = t.right;
			} else {
				if(c > 0) {
					stack = [CLJUtils cons:t to:stack];
					t = t.right;
				} else {
					t = t.left;
				}
			}
		}
		if(stack != nil) {
			return [[CLJSortedTreeSeq alloc] initWithStack:stack ascending:ascending];
		}
	}
	return nil;
}

//public NodeIterator iterator(){
//	return new NodeIterator(tree, true);
//}

//public Object kvreduce(IFn f, Object init){
//    if(tree != nil)
//        init = tree.kvreduce(f,init);
//    if(RT.isReduced(init))
//        init = ((IDeref)init).deref();
//    return init;
//}


//public NodeIterator reverseIterator(){
//	return new NodeIterator(tree, false);
//}

//- (id<CLJISet>)allKeys {
//	return keys(iterator());
//}
//
//public Iterator vals(){
//	return vals(iterator());
//}

//public Iterator keys(NodeIterator it){
//	return new KeyIterator(it);
//}
//
//public Iterator vals(NodeIterator it){
//	return new ValIterator(it);
//}

- (id)minKey {
	CLJTreeNode *t = self.min;
	return t != nil ? t.key : nil;
}

- (CLJTreeNode *)min {
	CLJTreeNode *t = _tree;
	if(t != nil) {
		while (t.left != nil) {
			t = t.left;
		}
	}
	return t;
}

- (id)maxKey {
	CLJTreeNode *t = self.max;
	return t != nil ? t.key : nil;
}

- (CLJTreeNode *)max {
	CLJTreeNode *t = _tree;
	if(t != nil) {
		while (t.right != nil) {
			t = t.right;
		}
	}
	return t;
}

- (int)depth {
	return [self depth:_tree];
}

- (int)depth:(CLJTreeNode *)t {
	if(t == nil) {
		return 0;
	}
	return 1 + MAX([self depth:t.left], [self depth:t.right]);
}

- (id)objectForKey:(id)key default:(id)notFound {
	CLJTreeNode *n = (CLJTreeNode *)[self entryForKey:key];
	return (n != nil) ? n.val : notFound;
}

- (id)objectForKey:(id)key {
	return [self objectForKey:key default:nil];
}

- (NSInteger)capacity {
	return _count;
}

- (NSUInteger)count {
	return _count;
}

- (id<CLJIMapEntry>)entryForKey:(id)aKey {
	CLJTreeNode *t = _tree;
	while(t != nil) {
		int c = [self doCompare:aKey :t.key];
		if(c == 0) {
			return t;
		} else if(c < 0) {
			t = t.left;
		} else {
			t = t.right;
		}
	}
	return t;
}

- (NSComparisonResult)doCompare:(id)k1 :(id)k2 {
	//	if(comp != nil)
	return _comp(k1, k2);
	//	return ((Comparable) k1).compareTo(k2);
}

- (CLJTreeNode *)add:(CLJTreeNode *)t key:(id)key val:(id)val found:(CLJBox *)found {
	if(t == nil) {
		if(val == nil) {
			return [[CLJRedTreeNode alloc] initWithKey:key];
		}
		return [[CLJRedTreeValue alloc] initWithKey:key val:val];
	}
	int c = [self doCompare:key :t.key];
	if(c == 0) {
		found.val = t;
		return nil;
	}
	CLJTreeNode *ins = c < 0 ? [self add:t.left key:key val:val found:found] : [self add:t.right key:key val:val found:found];
	if(ins == nil) {//found below
		return nil;
	}
	if(c < 0) {
		return [t addLeft:ins];
	}
	return [t addRight:ins];
}

- (CLJTreeNode *)remove:(CLJTreeNode *)t key:(id)key found:(CLJBox *)found {
	if(t == nil) {
		return nil; //not found indicator
	}
	int c = [self doCompare:key :t.key];
	if(c == 0) {
		found.val = t;
		return [CLJPersistentTreeMap append:t.left :t.right];
	}
	CLJTreeNode *del = c < 0 ? [self remove:t.left key:key found:found] : [self remove:t.right key:key found:found];
	if(del == nil && found.val == nil) {//not found below
		return nil;
	}
	if(c < 0) {
		if([t.left isKindOfClass:CLJBlackTreeNode.class]) {
			return [CLJPersistentTreeMap balanceLeftDel:t.key val:t.val del:del right:t.right];
		} else {
			return [CLJPersistentTreeMap red:t.key val:t.val left:del right:t.right];
		}
	}
	if([t.right isKindOfClass:CLJBlackTreeNode.class]) {
		return [CLJPersistentTreeMap balanceRightDel:t.key val:t.val del:del left:t.left];
	}
	return [CLJPersistentTreeMap red:t.key val:t.val left:t.left right:del];
	//		return t.removeLeft(del);
	//	return t.removeRight(del);
}

+ (CLJTreeNode *)append:(CLJTreeNode *)left :(CLJTreeNode *)right {
	if(left == nil)
		return right;
	else if(right == nil) {
		return left;
	} else if([left isKindOfClass:CLJRedTreeNode.class]) {
		if([right isKindOfClass:CLJRedTreeNode.class]) {
			CLJTreeNode *app = [CLJPersistentTreeMap append:left.right :right.left];
			if([app isKindOfClass:CLJRedTreeNode.class]) {
				return [CLJPersistentTreeMap red:app.key val:app.val
											left:[CLJPersistentTreeMap red:left.key val:left.val left:left.left right:app.left]
										   right:[CLJPersistentTreeMap red:right.key val:right.val left:app.right right:right.right]];
			} else {
				return [CLJPersistentTreeMap red:left.key val:left.val left:left.left right:[CLJPersistentTreeMap red:right.key val:right.val left:app right:right.right]];
			}
		} else {
			return [CLJPersistentTreeMap red:left.key val:left.val left:left.left right:[CLJPersistentTreeMap append:left.right :right]];
		}
	} else if([right isKindOfClass:CLJRedTreeNode.class]) {
		return [CLJPersistentTreeMap red:right.key val:right.val
									left:[CLJPersistentTreeMap append:left :right.left] right:right.right];
	} else { //black/black
		CLJTreeNode *app = [CLJPersistentTreeMap append:left.right :right.left];
		if([app isKindOfClass:CLJRedTreeNode.class]) {
			return [CLJPersistentTreeMap red:app.key val:app.val
										left:[CLJPersistentTreeMap black:left.key val:left.val left:left.left right:app.left]
									   right:[CLJPersistentTreeMap black:right.key val:right.val left:app.right right:right.right]];
		} else {
			return [CLJPersistentTreeMap balanceLeftDel:left.key val:left.val del:left.left right:[CLJPersistentTreeMap black:right.key val:right.val left:app right:right.right]];
		}
	}
}

+ (CLJTreeNode *)balanceLeftDel:(id)key val:(id)val del:(CLJTreeNode *)del right:(CLJTreeNode *)right {
	if([del isKindOfClass:CLJRedTreeNode.class]) {
		return [CLJPersistentTreeMap red:key val:val left:del.blacken right:right];
	} else if([right isKindOfClass:CLJBlackTreeNode.class]) {
		return [CLJPersistentTreeMap rightBalance:key val:val left:del ins:right.redden];
	} else if([right isKindOfClass:CLJRedTreeNode.class] && [right.left isKindOfClass:CLJBlackTreeNode.class]) {
		return [CLJPersistentTreeMap red:right.left.key val:right.left.val
									left:[CLJPersistentTreeMap black:key val:val left:del right:right.left.left]
								   right:[CLJPersistentTreeMap rightBalance:right.key val:right.val left:right.left.right ins:right.right.redden]];
	} else {
		[NSException raise:NSInternalInconsistencyException format:@"Invariant violation"];
	}
	return nil;
}

+ (CLJTreeNode *)balanceRightDel:(id)key val:(id)val del:(CLJTreeNode *)del left:(CLJTreeNode *)left {
	if([del isKindOfClass:CLJRedTreeNode.class]) {
		return [CLJPersistentTreeMap red:key val:val left:left right:del.blacken];
	} else if([left isKindOfClass:CLJBlackTreeNode.class]) {
		return [CLJPersistentTreeMap leftBalance:key val:val ins:left.redden right:del];
	} else if([left isKindOfClass:CLJRedTreeNode.class] && [left.right isKindOfClass:CLJBlackTreeNode.class]) {
		return [CLJPersistentTreeMap red:left.right.key val:left.right.val
									left:[CLJPersistentTreeMap leftBalance:left.key val:left.val ins:left.left.redden right:left.right.left]
								   right:[CLJPersistentTreeMap black:key val:val left:left.right.right right:del]];
	} else {
		[NSException raise:NSInternalInconsistencyException format:@"Invariant violation"];
	}
	return nil;
}

+ (CLJTreeNode *)leftBalance:(id)key val:(id)val ins:(CLJTreeNode *)ins right:(CLJTreeNode *)right {
	if([ins isKindOfClass:CLJRedTreeNode.class] && [ins.left isKindOfClass:CLJRedTreeNode.class]) {
		return [CLJPersistentTreeMap red:ins.key val:ins.val left:ins.left.blacken right:[CLJPersistentTreeMap black:key val:val left:ins.right right:right]];
	} else if([ins isKindOfClass:CLJRedTreeNode.class] && [ins.right isKindOfClass:CLJRedTreeNode.class]) {
		return [CLJPersistentTreeMap red:ins.right.key val:ins.right.val
									left:[CLJPersistentTreeMap black:ins.key val:ins.val left:ins.left right:ins.right.left]
								   right:[CLJPersistentTreeMap black:key val:val left:ins.right.right right:right]];
	} else {
		return [CLJPersistentTreeMap black:key val:val left:ins right:right];
	}
}


+ (CLJTreeNode *)rightBalance:(id)key val:(id)val left:(CLJTreeNode *)left ins:(CLJTreeNode *)ins {
	if([ins isKindOfClass:CLJRedTreeNode.class] && [ins.right isKindOfClass:CLJRedTreeNode.class]) {
		return [CLJPersistentTreeMap red:ins.key val:ins.val
									left:[CLJPersistentTreeMap black:key val:val left:left right:ins.left]
								   right:ins.right.blacken];
	} else if([ins isKindOfClass:CLJRedTreeNode.class] && [ins.left isKindOfClass:CLJRedTreeNode.class]) {
		return [CLJPersistentTreeMap red:ins.left.key val:ins.left.val
									left:[CLJPersistentTreeMap black:key val:val left:left right:ins.left.left]
								   right:[CLJPersistentTreeMap black:ins.key val:ins.val left:ins.left.right right:ins.left.val]];
	} else {
		return [CLJPersistentTreeMap black:key val:val left:left right:ins];
	}
}

- (CLJTreeNode *)replace:(CLJTreeNode *)t key:(id)key val:(id)val {
	int c = [self doCompare:key :t.key];
	return [t replaceKey:t.key
				 byValue:(c == 0) ? val : t.val
					left:(c < 0) ? [self replace:t.left key:key val:val] : t.left
				   right:(c > 0) ? [self replace:t.right key:key val:val] : t.right];
}

+ (CLJRedTreeNode *)red:(id)key val:(id)val left:(CLJTreeNode *)left right:(CLJTreeNode *)right {
	if(left == nil && right == nil) {
		if(val == nil) {
			return [[CLJRedTreeNode alloc] initWithKey:key];
		}
		return [[CLJRedTreeValue alloc] initWithKey:key val:val];
	}
	if(val == nil) {
		return [[CLJRedTreeBranch alloc] initWithKey:key left:left right:right];
	}
	return [[CLJRedTreeBranchValue alloc] initWithKey:key val:val left:left right:right];
}

+ (CLJBlackTreeNode *)black:(id)key val:(id)val left:(CLJTreeNode *)left right:(CLJTreeNode *)right {
	if(left == nil && right == nil) {
		if(val == nil) {
			return [[CLJBlackTreeNode alloc] initWithKey:key];
		}
		return [[CLJBlackTreeValue alloc] initWithKey:key val:val];
	}
	if(val == nil) {
		return [[CLJBlackTreeBranch alloc] initWithKey:key left:left right:right];
	}
	return [[CLJBlackTreeBranchValue alloc] initWithKey:key val:val left:left right:right];
}

- (id<CLJIPersistentMap>)meta {
	return _meta;
}


//static public class NodeIterator implements Iterator{
//	Stack stack = new Stack();
//	boolean asc;
//	
//	NodeIterator(Node t, boolean asc){
//		this.asc = asc;
//		push(t);
//	}
//	
//	void push(Node t){
//		while(t != nil)
//		{
//			stack.push(t);
//			t = asc ? t.left() : t.right();
//		}
//	}
//	
//	public boolean hasNext(){
//		return !stack.isEmpty();
//	}
//	
//	public Object next(){
//		Node t = (Node) stack.pop();
//		push(asc ? t.right() : t.left());
//		return t;
//	}
//	
//	public void remove(){
//		throw new UnsupportedOperationException();
//	}
//}
//
//static class KeyIterator implements Iterator{
//	NodeIterator it;
//	
//	KeyIterator(NodeIterator it){
//		this.it = it;
//	}
//	
//	public boolean hasNext(){
//		return it.hasNext();
//	}
//	
//	public Object next(){
//		return ((Node) it.next()).key;
//	}
//	
//	public void remove(){
//		throw new UnsupportedOperationException();
//	}
//}
//
//static class ValIterator implements Iterator{
//	NodeIterator it;
//	
//	ValIterator(NodeIterator it){
//		this.it = it;
//	}
//	
//	public boolean hasNext(){
//		return it.hasNext();
//	}
//	
//	public Object next(){
//		return ((Node) it.next()).val();
//	}
//	
//	public void remove(){
//		throw new UnsupportedOperationException();
//	}
//}



/*
 static public void main(String args[]){
 if(args.length != 1)
 System.err.println("Usage: RBTree n");
 int n = Integer.parseInt(args[0]);
 Integer[] ints = new Integer[n];
 for(int i = 0; i < ints.length; i++)
 {
 ints[i] = i;
 }
 Collections.shuffle(Arrays.asList(ints));
 //force the ListMap class loading now
 //	try
 //		{
 //
 //		//PersistentListMap.EMPTY.assocEx(1, nil).assocEx(2,nil).assocEx(3,nil);
 //		}
 //	catch(Exception e)
 //		{
 //		e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
 //		}
 System.out.println("Building set");
 //IPersistentMap set = new PersistentArrayMap();
 //IPersistentMap set = new PersistentHashtableMap(1001);
 IPersistentMap set = PersistentHashMap.EMPTY;
 //IPersistentMap set = new ListMap();
 //IPersistentMap set = new ArrayMap();
 //IPersistentMap set = new PersistentTreeMap();
 //	for(int i = 0; i < ints.length; i++)
 //		{
 //		Integer anInt = ints[i];
 //		set = set.add(anInt);
 //		}
 long startTime = System.nanoTime();
 for(Integer anInt : ints)
 {
 set = set.assoc(anInt, anInt);
 }
 //System.out.println("_count = " + set.count());
 
 //	System.out.println("_count = " + set._count + ", min: " + set.minKey() + ", max: " + set.maxKey()
 //	                   + ", depth: " + set.depth());
 for(Object aSet : set)
 {
 IMapEntry o = (IMapEntry) aSet;
 if(!set.contains(o.key()))
 System.err.println("Can't find: " + o.key());
 //else if(n < 2000)
 //	System.out.print(o.key().toString() + ",");
 }
 
 Random rand = new Random(42);
 for(int i = 0; i < ints.length / 2; i++)
 {
 Integer anInt = ints[rand.nextInt(n)];
 set = set.without(anInt);
 }
 
 long estimatedTime = System.nanoTime() - startTime;
 System.out.println();
 
 System.out.println("_count = " + set.count() + ", time: " + estimatedTime / 1000000);
 
 System.out.println("Building ht");
 Hashtable ht = new Hashtable(1001);
 startTime = System.nanoTime();
 //	for(int i = 0; i < ints.length; i++)
 //		{
 //		Integer anInt = ints[i];
 //		ht.put(anInt,nil);
 //		}
 for(Integer anInt : ints)
 {
 ht.put(anInt, anInt);
 }
 //System.out.println("size = " + ht.size());
 //Iterator it = ht.entrySet().iterator();
 for(Object o1 : ht.entrySet())
 {
 Map.Entry o = (Map.Entry) o1;
 if(!ht.containsKey(o.getKey()))
 System.err.println("Can't find: " + o);
 //else if(n < 2000)
 //	System.out.print(o.toString() + ",");
 }
 
 rand = new Random(42);
 for(int i = 0; i < ints.length / 2; i++)
 {
 Integer anInt = ints[rand.nextInt(n)];
 ht.remove(anInt);
 }
 estimatedTime = System.nanoTime() - startTime;
 System.out.println();
 System.out.println("size = " + ht.size() + ", time: " + estimatedTime / 1000000);
 
 System.out.println("set lookup");
 startTime = System.nanoTime();
 int c = 0;
 for(Integer anInt : ints)
 {
 if(!set.contains(anInt))
 ++c;
 }
 estimatedTime = System.nanoTime() - startTime;
 System.out.println("notfound = " + c + ", time: " + estimatedTime / 1000000);
 
 System.out.println("ht lookup");
 startTime = System.nanoTime();
 c = 0;
 for(Integer anInt : ints)
 {
 if(!ht.containsKey(anInt))
 ++c;
 }
 estimatedTime = System.nanoTime() - startTime;
 System.out.println("notfound = " + c + ", time: " + estimatedTime / 1000000);
 
 //	System.out.println("_count = " + set._count + ", min: " + set.minKey() + ", max: " + set.maxKey()
 //	                   + ", depth: " + set.depth());
 }
 */

@end
