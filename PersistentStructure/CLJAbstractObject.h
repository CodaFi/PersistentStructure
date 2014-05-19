//
//  CLJAbstractObject.h
//  NUIKit
//
//  Created by Robert Widmann on 5/7/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

/// Enforces a notion of abstract methods in an Objective-C class.
///
/// Requesting a concrete implementation is akin to marking a method abstract in a language like
/// Java.  If a method that calls through to this function is invoked, the program will immediately
/// terminate and print a message to the console about the violated invariant.
///
/// This function expects the instance of the object, the name of the current selector, and an
/// optional expected class.  If the expected class is provided, and it does not match the type of
/// the provided object, then it will be assumed that some subclass has failed to override an
/// abstract method.  If the expected class is provided and it does match the type of the provided
/// object, then it is assumed that the user has attempted to invoke an abstract method.  Pass Nil
/// to this parameter if you do not wish to provide an expected class.
extern void CLJRequestConcreteImplementation(id obj, SEL s, Class expectedClass);
