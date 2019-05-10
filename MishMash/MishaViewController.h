//
//  ViewController.h
//  MishMash
//
//  Created by Henry Lowengard on 4/10/19.
//  Copyright © 2019 net.jhhl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UILabeledButton.h"
 #import "DegreeTouchView.h" // owns the degreebuttons, sliders, ste.

@interface MishaViewController : UIViewController
<
DegreeTouchViewDelegate
>

@property (strong,nonatomic,nonnull) IBOutlet UIStackView * stk_controls;
@property (strong,nonatomic,nonnull) IBOutlet DegreeTouchView * dtv_view;

// toolbar buttons
@property (strong,nonatomic,nonnull) IBOutlet UILabeledButton * bt_key;
@property (strong,nonatomic,nonnull) IBOutlet UILabeledButton * bt_scale;

@property (strong,nonatomic,nonnull) IBOutlet UILabeledButton * bt_chordMode;
@property (strong,nonatomic,nonnull) IBOutlet UILabeledButton * bt_presets;
@property (strong,nonatomic,nonnull) IBOutlet UILabeledButton * bt_info;

// will be laid out algorithmically
@property (strong,nonatomic,nonnull) IBOutlet UIView * vw_container;
// what are these?
@property (strong,nonatomic,nonnull) IBOutlet UILabeledButton * bt_home;
@property (strong,nonatomic,nonnull) IBOutlet UILabeledButton * bt_undo;
@property (strong,nonatomic,nonnull) IBOutlet UILabeledButton * bt_midi;


- (IBAction) act_key:(UILabeledButton * _Nonnull) button;
- (IBAction) act_scale:(UILabeledButton * _Nonnull) button;
- (IBAction) act_home:(UILabeledButton * _Nonnull) button;
- (IBAction) act_undo:(UILabeledButton * _Nonnull) button;
 - (IBAction) act_chordMode:(UILabeledButton * _Nonnull) button;
- (IBAction) act_presets:(UILabeledButton * _Nonnull) button;
- (IBAction) act_midi:(UILabeledButton * _Nonnull) button;
- (IBAction) act_info:(UILabeledButton * _Nonnull) button;

 @end

