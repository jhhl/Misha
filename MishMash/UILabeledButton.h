//
//  UILabeledButton.h
//  MishMash
//
//  Created by Henry Lowengard on 4/12/19.
//  Copyright © 2019 net.jhhl. All rights reserved.
// may be Midified and skinned

#import <UIKit/UIKit.h>
#import "Skin.h"
#import "MIDIMapAddress.h"

typedef NS_ENUM(NSUInteger, LabeledButtonStyle)
{
    LBS_NONE,
    LBS_RECT,
    LBS_ROUNDRECT,
    LBS_SEMICIRCLE
};

NS_ASSUME_NONNULL_BEGIN

@interface UILabeledButton : UIButton

@property LabeledButtonStyle lbs_style;
@property(strong) MIDIMapAddress* mmapAddr;
@end

NS_ASSUME_NONNULL_END
