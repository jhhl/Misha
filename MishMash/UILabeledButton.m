//
//  UILabeledButton.m
//  MishMash
//
//  Created by Henry Lowengard on 4/12/19.
//  Copyright © 2019 net.jhhl. All rights reserved.
//

#import "UILabeledButton.h"

@implementation UILabeledButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)initInnards
{
    self.titleLabel.numberOfLines=2;
    self.titleLabel.adjustsFontSizeToFitWidth=YES;
    self.titleLabel.minimumScaleFactor=0.25;
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.mmapAddr.mappedMidiCommand=0;
    self.mmapAddr.mappedMidiData=0;
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
