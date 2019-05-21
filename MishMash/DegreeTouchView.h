//
//  DegreeTouchView.h
//  MishMash
//
//  Created by Henry Lowengard on 5/1/19.
//  Copyright © 2019 net.jhhl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DegreeButton.h"
#import "ScalePieView.h"
#import "MishaSlider.h"
#import "UILabeledButton.h"

NS_ASSUME_NONNULL_BEGIN
#define DEGREE_BUTTON_RANGE 4

@class DegreeTouchView;
@protocol DegreeTouchViewDelegate
-(void) dtviewChanged:(DegreeTouchView*) dtv;
-(void) dtviewNoff:(DegreeTouchView*) dtv;
-(void) dtviewButtonTouched:(UILabeledButton *) b type:(int) type;
@end

@interface DegreeTouchView : UIView
<
DegreeButtonDelegate
>

@property (assign) id<DegreeTouchViewDelegate> delegate;

@property (strong,nonatomic,nonnull) IBOutlet ScalePieView * spv_pie;
@property (strong,nonatomic,nonnull) IBOutlet MishaSlider * ssl_bend; // zeroing slider.

@property (strong,nonatomic,nonnull) IBOutlet UILabeledButton * bt_home;
@property (strong,nonatomic,nonnull) IBOutlet UILabeledButton * bt_undo;
@property (strong,nonatomic,nonnull) IBOutlet UILabeledButton * bt_capo_down;
@property (strong,nonatomic,nonnull) IBOutlet UILabeledButton * bt_capo_up;

@property (strong,nonatomic,nonnull) NSMutableArray<DegreeButton *> * degreeButtons;
@end

NS_ASSUME_NONNULL_END
