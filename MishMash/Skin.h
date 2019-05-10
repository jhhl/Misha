//
//  Skin.h
//  MishMash
//
//  Created by Henry Lowengard on 4/10/19.
//  Copyright © 2019 net.jhhl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIColor+HTML.h"

#define SKIN_VERSION @"1"

NS_ASSUME_NONNULL_BEGIN

@interface Skin : NSObject

@property (strong,nonatomic,nonnull) NSString * name;

@property (strong,nonatomic,nonnull) UIColor * cl_bg_main;
@property (strong,nonatomic,nonnull) UIColor * cl_bg;

@property (strong,nonatomic,nonnull) UIColor * cl_lo;
@property (strong,nonatomic,nonnull) UIColor * cl_hi;

@property (strong,nonatomic,nonnull) UIColor * cl_edge1;
@property (strong,nonatomic,nonnull) UIColor * cl_edge2;

@property (strong,nonatomic,nonnull) UIColor * cl_lo_text;
@property (strong,nonatomic,nonnull) UIColor * cl_hi_text;

 
- (NSString *) toString;
- (void) fromString:(NSString *) data;
// might want to use angle creation etc.

@end

NS_ASSUME_NONNULL_END
