//
//  Skin.m
//  MishMash
//
//  Created by Henry Lowengard on 4/10/19.
//  Copyright © 2019 net.jhhl. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "Skin.h"

@implementation Skin

 
- (instancetype)init
{
    self = [super init];
    if (self) {
        _cl_bg_main=[UIColor colorWithHexString:@"CCD" ];
        _cl_bg=[UIColor colorWithHexString:@"EEE" ];
        _cl_lo=[UIColor colorWithHexString:@"341" ];
        _cl_hi=[UIColor colorWithHexString:@"ce9" ];
        _cl_edge1=[UIColor colorWithHexString:@"227" ];
        _cl_edge2=[UIColor colorWithHexString:@"384" ];
        _cl_lo_text=[UIColor colorWithHexString:@"884" ];
        _cl_hi_text=[UIColor colorWithHexString:@"fe8" ];
    }
    return self;
}

// hmm. do this or the dictionary thing?
- (NSString *) toString
{
    NSMutableString *  s = [[NSMutableString alloc] init];
    [s appendFormat:@"{"];
    [s appendFormat:@"\"version\": \"%@\", \"%@\"\n",SKIN_VERSION,_name];
    // add each color
    [s appendFormat:@"\"bgMain\":\"%@\",\n",[_cl_bg_main htmlHexString]];
    [s appendFormat:@"\"bg\":\"%@\",\n",[_cl_bg htmlHexString]];
    [s appendFormat:@"\"lo\":\"%@\",\n",[_cl_lo htmlHexString]];
    [s appendFormat:@"\"hi\":\"%@\",\n",[_cl_hi htmlHexString]];
    [s appendFormat:@"\"edge1\":\"%@\",\n",[_cl_edge1 htmlHexString]];
    [s appendFormat:@"\"edge2\":\"%@\",\n",[_cl_edge2 htmlHexString]];
    [s appendFormat:@"\"lo_text\":\"%@\",\n",[_cl_lo_text htmlHexString]];
    [s appendFormat:@"\"hi_text\":\"%@\"\n",[_cl_hi_text htmlHexString]];
    [s appendFormat:@"}"];
    return s;
}

- (void) fromString:(NSString *) data
{
    
}
@end
