//
//  Tools.m
//  4scan
//
//  Created by R4phaB on 9/11/14.
//  Copyright (c) 2014 R4phaB. All rights reserved.
//

#include <ifaddrs.h>
#include <arpa/inet.h>

#import "Tools.h"
#import "AppDelegate.h"
#import "Host.h"

@implementation Tools

+ (NSString*) convertBitmask:(NSString*) mask{
    
    NSMutableDictionary* masks = [NSMutableDictionary new];
    
    [masks setValue:@"/0" forKey:@"0x00000000"];
    [masks setValue:@"/1" forKey:@"0x80000000"];
    [masks setValue:@"/2" forKey:@"0xc0000000"];
    [masks setValue:@"/3" forKey:@"0xe0000000"];
    [masks setValue:@"/4" forKey:@"0xf0000000"];
    [masks setValue:@"/5" forKey:@"0xf8000000"];
    [masks setValue:@"/6" forKey:@"0xfc000000"];
    [masks setValue:@"/7" forKey:@"0xfe000000"];
    [masks setValue:@"/8" forKey:@"0xff000000"];
    [masks setValue:@"/9" forKey:@"0xff800000"];
    [masks setValue:@"/10" forKey:@"0xffc00000"];
    [masks setValue:@"/11" forKey:@"0xffe00000"];
    [masks setValue:@"/12" forKey:@"0xfff00000"];
    [masks setValue:@"/13" forKey:@"0xfff80000"];
    [masks setValue:@"/14" forKey:@"0xfffc0000"];
    [masks setValue:@"/15" forKey:@"0xfffe0000"];
    [masks setValue:@"/16" forKey:@"0xffff0000"];
    [masks setValue:@"/17" forKey:@"0xffff8000"];
    [masks setValue:@"/18" forKey:@"0xffffc000"];
    [masks setValue:@"/19" forKey:@"0xffffe000"];
    [masks setValue:@"/20" forKey:@"0xfffff000"];
    [masks setValue:@"/21" forKey:@"0xfffff800"];
    [masks setValue:@"/22" forKey:@"0xfffffc00"];
    [masks setValue:@"/23" forKey:@"0xfffffe00"];
    [masks setValue:@"/24" forKey:@"0xffffff00"];
    [masks setValue:@"/25" forKey:@"0xffffff80"];
    [masks setValue:@"/26" forKey:@"0xffffffc0"];
    [masks setValue:@"/27" forKey:@"0xffffffe0"];
    [masks setValue:@"/28" forKey:@"0xfffffff0"];
    [masks setValue:@"/29" forKey:@"0xfffffff8"];
    [masks setValue:@"/30" forKey:@"0xfffffffc"];
    [masks setValue:@"/31" forKey:@"0xfffffffe"];
    [masks setValue:@"/32" forKey:@"0xffffffff"];

    return [masks valueForKey:[mask stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];

}

+(NSString*)getCMD{
    NSArray *myIps = [[Tools execute:@"ifconfig | grep broadcast | awk '{print $2}'"] componentsSeparatedByString:@"\n"];
    NSArray *myMasks = [[Tools execute:@"ifconfig | grep broadcast | awk '{print $4}'"] componentsSeparatedByString:@"\n"];
    
    NSString* scanCMD = [[NSBundle mainBundle] pathForResource:@"nmap" ofType:@""];
    scanCMD = [scanCMD stringByAppendingString:@" -sP "];
    scanCMD = [scanCMD stringByAppendingString:[myIps firstObject]];
    scanCMD = [scanCMD stringByAppendingString:[self convertBitmask:[myMasks firstObject]]];

    
    return scanCMD;
}

+ (NSMutableArray*)scanMyLan{
    
    [Tools execute:[self getCMD]];
        
    NSString* arp = [Tools execute:@"arp -a | grep -v incomplete | awk '{print $2 \"---\" $1 \"---\" $4}'"];
    
    NSArray* hosts = [arp componentsSeparatedByString:@"\n"];
    
    NSMutableArray* final = [NSMutableArray new];
    NSMutableArray* ips = [NSMutableArray new];
    
    for(int i = 0; i < [hosts count]; i++){
        
        NSArray *parts = [[hosts objectAtIndex:i] componentsSeparatedByString:@"---"];
        
        if([parts count] < 2){
            continue;
        }
        
        Host* host = [Host new];
        
        NSString* ip = [[[[parts objectAtIndex:0]stringByReplacingOccurrencesOfString:@"(" withString:@""] stringByReplacingOccurrencesOfString:@")" withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        [host setIp:ip];
        
        NSString* name = ([[parts objectAtIndex:1] rangeOfString:@"?"].location != NSNotFound) ? [parts objectAtIndex:2] : [parts objectAtIndex:1];

        // Fix missing leading 0
        if([name length] == 16 && [name containsString:@":"])
            name = [NSString stringWithFormat:@"%@%@", @"0", name];
        
        [host setName:name];
        
        // Check bad IP and Name
        if ([[host name] rangeOfString:@"ff:ff:ff:ff:ff:ff"].location == NSNotFound && ![[host ip] hasPrefix:@"169."] && ![[host ip] hasSuffix:@".0"] && ![[host ip] hasSuffix:@".255"]) {
            
            [final addObject:host];
            [ips addObject:ip];
        }
        
    }
    
    return final;
    
}

+ (NSString*)execute:(NSString*) command
{
    NSTask *task;
    task = [[NSTask alloc] init];
    [task setLaunchPath: @"/bin/sh"];
    
    NSArray *arguments = [NSArray arrayWithObjects:
                          @"-c" ,
                          [NSString stringWithFormat:@"%@", command],
                          nil];

    [task setArguments: arguments];
    
    NSPipe *pipe;
    pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
    
    NSFileHandle *file;
    file = [pipe fileHandleForReading];
    
    [task launch];
    
    NSData *data;
    data = [file readDataToEndOfFile];
    
    NSString *output;
    output = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    return output;
}

@end
