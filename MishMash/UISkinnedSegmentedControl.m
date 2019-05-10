//
//  UISkinnedSegmentedControl.m
//  MishMash
//
//  Created by Henry Lowengard on 5/6/19.
//  Copyright © 2019 net.jhhl. All rights reserved.
//

#import "UISkinnedSegmentedControl.h"
#import "Skins.h"

@implementation UISkinnedSegmentedControl

- (void)initInnards
{
     [Skins afterChangingSkinDoThis:^(Skin * s)
     {
         self.backgroundColor = s.cl_lo;
         self.tintColor = s.cl_hi_text;
     }];
}
// good old init
- (instancetype)initWithFrame:(CGRect) frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initInnards];
    }
    return self;
}
// for nibs
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initInnards];
    }
    return self;
}
@end
