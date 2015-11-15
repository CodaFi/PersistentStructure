//
//  CLJTransientsSpec.m
//  PersistentStructure
//
//  Created by Robert Widmann on 3/28/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

CLJTestBegin(CLJTransients)

- (void)testDissocing {
	
}

- (void)testEmptyTransient {
	XCTAssertFalse(CLJContains(
						CLJCreateTransient(
							CLJCreateHashSet(nil)), @"bogus-key"),
								@"");
}

CLJTestEnd
