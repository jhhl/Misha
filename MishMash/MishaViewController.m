//
//  ViewController.m
//  MishMash
//
//  Created by Henry Lowengard on 4/10/19.
//  Copyright © 2019 net.jhhl. All rights reserved.
//

#import "MishaViewController.h"
#import "Skins.h"
#import "Scales.h"
#import "MIDIManager.h"
#import "ScalePickerViewController.h"
#import "KeyPickerViewController.h"
#import "MIDIViewController.h"

@interface MishaViewController ()

@end

@implementation MishaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // IB doesn't let you get this dep in a uibutton
    for(id item in _stk_controls.subviews)
    {
        if([item isKindOfClass:[UIButton class]])
        {
            UIButton * b = item;
            b.titleLabel.minimumScaleFactor=0.5;
        }
    }
    
    _dtv_view.delegate = self;
    
    // all the other skinnables should be set by now I hope
    [Skins._  setSkinToPresetNamed:@"Default"];
}

#pragma mark ViewController methods
- (void) viewWillAppear:(BOOL) animated
{
    [super viewWillAppear:animated];
    // could be back from scale or other change.
    [self updateUI];
    
}
- (void) viewDidAppear:(BOOL) animated
{
    [super viewDidAppear:animated];
    
}
- (void) viewWillDisappear:(BOOL) animated
{
    [super viewWillDisappear:animated];
    
}
- (void) viewDidDisappear:(BOOL) animated
{
    [super viewDidDisappear:animated];
    
}
//MARK: - update UI
- (void) updateUI
{
    NSString * scaleName = Scales._.scale.name;
    [_bt_scale setTitle:[NSString stringWithFormat:@"Scale: %@",scaleName] forState:UIControlStateNormal];
    NSString * baseName = Scales._.scale.scaleNodeBaseNode.note.name;
    [_bt_key setTitle:[NSString stringWithFormat:@"Key: %@",baseName] forState:UIControlStateNormal];

    [_dtv_view.spv_pie setNeedsDisplay];
}
//MARK: acts
- (IBAction) act_key:(UIButton * _Nonnull) button
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    KeyPickerViewController * kpvc =      (KeyPickerViewController *) [sb instantiateViewControllerWithIdentifier:@"KeyPickerViewController"];
    [self presentViewController:kpvc animated:YES completion:^{
        
    }];
}
- (IBAction) act_scale:(UIButton * _Nonnull) button
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ScalePickerViewController * spvc =      (ScalePickerViewController *) [sb instantiateViewControllerWithIdentifier:@"ScalePickerViewController"];
    [self presentViewController:spvc animated:YES completion:^{
        
    }];
}
- (IBAction) act_home:(UIButton * _Nonnull) button
{
    
}
- (IBAction) act_undo:(UIButton * _Nonnull) button
{
}

- (IBAction) act_chordMode:(UIButton * _Nonnull) button
{
}
- (IBAction) act_presets:(UIButton * _Nonnull) button
{
}
- (IBAction) act_midi:(UIButton * _Nonnull) button
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MIDIViewController * midivc =      (MIDIViewController *) [sb instantiateViewControllerWithIdentifier:@"MIDIViewController"];
    [self presentViewController:midivc animated:YES completion:^{
        
    }];
}
- (IBAction) act_info:(UIButton * _Nonnull) button
{
    [MIDIManager._ ANO];
}

//MARK: - DegreeTouchViewDelegate
-(void) dtviewChanged:(DegreeTouchView*) dtv;
{
    // oh yeah.
    dmidi newNote = Scales._.cursor.note.dmidi;
//    [MIDIManager._ noteOnAndOff:newNote vel:0.8];
    [MIDIManager._ noteOnMono:newNote vel:0.8];
}

-(void) dtviewNoff:(DegreeTouchView*) dtv;
{
    // this note is actually irrelevant -
    dmidi newNote = Scales._.cursor.note.dmidi;
   [MIDIManager._ noteOffMono:newNote vel:0.8];
}

-(void) dtviewButtonTouched:(UILabeledButton *) b type:(int) type;
{
    if(type == 1)
    {
        //home
        Scales._.cursor = Scales._.scale.scaleNodeBaseNode;
        [_dtv_view.spv_pie setNeedsDisplay];
    }
    if(type == 2)
    {
        //undo
    }
    if(type == 3)
    {
        //capo_up
    }
    if(type == 4)
    {
        //capo_down
    }
}
@end
