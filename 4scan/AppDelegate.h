//
//  AppDelegate.h
//  4scan
//
//  Created by R4phaB on 7/3/14.
//  Copyright (c) 2014 R4phaB. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property IBOutlet NSMenu* menu;
@property NSStatusItem *statusItem;
@property NSMutableArray* hosts;

- (void)createNewDisabledItem:(NSString*) title;

@end
