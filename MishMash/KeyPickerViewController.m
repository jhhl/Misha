//
//  KeyPickerViewController.m
//  MishMash
//
//  Created by Henry Lowengard on 4/12/19.
//  Copyright © 2019 net.jhhl. All rights reserved.
//

#import "KeyPickerViewController.h"
#import "Scales.h"

@interface KeyPickerViewController ()

@end

@implementation KeyPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

 
#pragma mark ViewController methods
- (void) viewWillAppear:(BOOL) animated
{
    [super viewWillAppear:animated];
    tempKey = Scales._.scale.base;
    NSInteger rowNotes = floor(fmod(tempKey,12));
    NSInteger rowOctaves = tempKey/12;

    [_pv_keys  selectRow:rowNotes inComponent:0 animated:NO];
    [_pv_keys  selectRow:rowOctaves inComponent:1 animated:NO];
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

- (IBAction) act_cancel
{
    [self  dismissViewControllerAnimated: YES completion: ^(){
        
    }];
}
- (IBAction) act_done
{
    Scales._.scale.base = tempKey;
    Scales._.scale.scaleNodeBaseNode.note.dmidi = tempKey;
    [Scales._.scale digestPattern: Scales._.scale.pattern base:tempKey];
    Scales._.cursor = Scales._.scale.scaleNodeBaseNode;
    [self  dismissViewControllerAnimated: YES completion: ^(){
        
    }];
}

#pragma mark picker Data Source
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return component==0?12:11;
}

#pragma mark - picker delegate
// use one of these

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
   
    tempKey =[pickerView selectedRowInComponent:0]+[pickerView selectedRowInComponent:1]*12;
    tempKey = MAX(0,MIN(127,tempKey));
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30.0;
}
// use one of these.
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString * title=@"";
    if(component ==0)
    {
        title=MIKMIDINoteLetterForMIDINoteNumber(row);
    }
    if(component ==1)
    {
        title=[NSString stringWithFormat:@"%d",(int)row];
    }
    return title;
}
/*
 - (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
 {
 return NULL;
 }
 */
/*
 - (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
 {
 return NULL;
 }
 */
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 60.0;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
