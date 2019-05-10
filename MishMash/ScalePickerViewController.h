//
//  ScalePIckerViewController.h
//  MishMash
//
//  Created by Henry Lowengard on 4/12/19.
//  Copyright © 2019 net.jhhl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Scales.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScalePickerViewController : UIViewController
<
UIPickerViewDelegate,
UIPickerViewDataSource
>
{
    Scale * tempScale;
}
@property (strong,nonatomic) IBOutlet UIButton * bt_done;
@property (strong,nonatomic) IBOutlet UIButton * bt_cancel;
@property (strong,nonatomic) IBOutlet UIPickerView * pv_scales;

- (IBAction) act_cancel;
- (IBAction) act_done;
 
@end

NS_ASSUME_NONNULL_END
