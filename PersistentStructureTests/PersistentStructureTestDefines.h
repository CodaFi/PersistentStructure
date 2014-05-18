//
//  PersistentStructureTests.h
//  PersistentStructure
//
//  Created by Robert Widmann on 3/27/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#ifndef PersistentStructure_PersistentStructureTests_h
#define PersistentStructure_PersistentStructureTests_h

#if defined(SENTEST_EXPORT)
	#define CLJTestBegin(CLASS) @interface CLASS##Spec : SenTestCase @end \
	@implementation CLASS##Spec
#elif defined(XCT_EXPORT)
	#define CLJTestBegin(CLASS) @interface CLASS##Spec : XCTestCase @end \
	@implementation CLASS##Spec
#endif

#define CLJTestEnd @end

#endif
