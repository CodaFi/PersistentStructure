//
//  CLJAbstractObject.c
//  PersistentStructure
//
//  Created by Robert Widmann on 5/18/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//

#import "CLJAbstractObject.h"
#include <objc/objc.h>
#include <objc/runtime.h>

void CLJRequestConcreteImplementation(id obj, SEL s, Class expectedClass) {
	Class c = [obj class];
	const char *selName = sel_getName(s);
	const char *className = class_getName(c) ?: "Nil";
	if (c != expectedClass) {
		[NSException raise:NSInvalidArgumentException format:@"*** -%s only defined for abstract class.  Define -[%s %s]!", selName, className, selName];
	} else {
		[NSException raise:NSInvalidArgumentException format:@"*** -%s cannot be sent to an abstract object of class %s: Create a concrete instance!", selName, class_getName(c)];
	}
}