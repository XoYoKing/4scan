//
//  AppDelegate.m
//  4scan
//
//  Created by R4phaB on 7/3/14.
//  Copyright (c) 2014 R4phaB. All rights reserved.
//

#import "AppDelegate.h"
#import "Tools.h"
#import "Host.h"

@implementation AppDelegate

@synthesize menu;
@synthesize statusItem;
@synthesize hosts;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
    menu = [NSMenu new];
    [menu setAutoenablesItems:NO];
    
    NSStatusBar *statusBar = [NSStatusBar systemStatusBar];
    statusItem = [statusBar statusItemWithLength:NSVariableStatusItemLength];

    [statusItem setImage:[NSImage imageNamed:@"icon.png"]];
    [statusItem setHighlightMode:NO];
    [statusItem setMenu:menu];
    
    [self performSelector:@selector(refresh:) withObject:nil afterDelay:0.0];
    
}

-(void)refresh:(id)sender{
    
    [menu removeAllItems];
    [self addRefreshItem];
    hosts = [Tools scanMyLan];
        
    for(Host *host in hosts){
        NSString* title = [[[host ip] stringByAppendingString:@" - "] stringByAppendingString:[host name]];
        [self createNewDisabledItem:title];
    }

    [menu addItem:[NSMenuItem separatorItem]];
    [self addQuitItem];
    
}

-(void) addQuitItem{
    NSMenuItem *tItem = nil;
    tItem = [menu addItemWithTitle:@"Quit" action:@selector(terminate:) keyEquivalent:@"q"];
    [tItem setKeyEquivalentModifierMask:NSCommandKeyMask];
}

-(void) addRefreshItem{
    NSMenuItem *tItem = nil;
    tItem = [menu addItemWithTitle:@"Refresh scan" action:@selector(refresh:) keyEquivalent:@"r"];
    [tItem setKeyEquivalentModifierMask:NSCommandKeyMask];
    [menu addItem:[NSMenuItem separatorItem]];
}

- (void) createNewDisabledItem:(NSString*) title{
    NSMenuItem* item = [NSMenuItem new];
    [item setTitle:title];
    [item setTarget:nil];
    [item setEnabled:NO];
    [item setAction:nil];
    [menu addItem:item];
}

@end