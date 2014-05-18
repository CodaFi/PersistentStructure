//
//  CLJBox.h
//  PersistentStructure
//
//  Created by Robert Widmann on 12/30/13.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//  Released under the MIT license.
//

#import <Foundation/Foundation.h>

@interface CLJBox : NSObject {
	id _val;
}

+ (instancetype)boxWithVal:(id)val;

@property (nonatomic) id val;

@end
