//
//  Tools.h
//  4scan
//
//  Created by R4phaB on 9/11/14.
//  Copyright (c) 2014 R4phaB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tools : NSObject

+ (NSString*)execute:(NSString*) command;
+ (NSMutableArray*)scanMyLan;
+ (NSString*)getCMD;

@end
