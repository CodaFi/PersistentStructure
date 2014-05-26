//
//  CLJIEditableCollection.h
//  PersistentStructure
//
//  Created by Robert Widmann on 12/30/13.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJITransientCollection.h"

/// The CLJIEditableCollection protocol describes the method for providing a transient (mutable)
/// copy of the reciever.
///
/// Transient collections permit mutations of their values without altering the underlying structure
/// or by making bulnk copies of their structure when they are mutated.
@protocol CLJIEditableCollection <NSObject>

/// Returns a new instance that's a transient copy of the reciever.
- (id<CLJITransientCollection>)asTransient;
@end
