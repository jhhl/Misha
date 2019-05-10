//
//  ScalePIckerViewController.m
//  MishMash
//
//  Created by Henry Lowengard on 4/12/19.
//  Copyright © 2019 net.jhhl. All rights reserved.
//

#import "ScalePickerViewController.h"

@interface ScalePickerViewController ()

@end

@implementation ScalePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}
#pragma mark ViewController methods
- (void) viewWillAppear:(BOOL) animated
{
    [super viewWillAppear:animated];
    tempScale = Scales._.scale;
    NSInteger scaleRow = [Scales._.sortedKeys indexOfObject:Scales._.scale.name];
    [_pv_scales  selectRow:scaleRow inComponent:0 animated:NO];
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
    Scales._.scale = tempScale;
    [Scales._.scale digestPattern: Scales._.scale.pattern base:60];
    Scales._.cursor = Scales._.scale.scaleNodeBaseNode;
    [self  dismissViewControllerAnimated: YES completion: ^(){
        
    }];
}
 
#pragma mark picker Data Source
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return Scales._.scales.count;
}

#pragma mark - picker delegate
// use one of these

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString * key =Scales._.sortedKeys[row];
    tempScale = Scales._.scales[key];
//    [tempScale digestPattern: tempScale.pattern base:60];
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30.0;
}
// use one of these.
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return Scales._.sortedKeys[row];
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
    return 120.0;
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
