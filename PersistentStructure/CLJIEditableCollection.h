//
//  CLJIEditableCollection.h
//  PersistentStructure
//
//  Created by Robert Widmann on 12/30/13.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import "CLJITransientCollection.h"

@protocol CLJIEditableCollection <NSObject>
- (id<CLJITransientCollection>)asTransient;
@end
