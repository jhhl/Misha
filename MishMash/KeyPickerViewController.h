//
//  KeyPickerViewController.h
//  MishMash
//
//  Created by Henry Lowengard on 4/12/19.
//  Copyright © 2019 net.jhhl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"

NS_ASSUME_NONNULL_BEGIN

@interface KeyPickerViewController : UIViewController
<
UIPickerViewDelegate,
UIPickerViewDataSource
>
{
    dmidi tempKey;
}
@property (strong,nonatomic) IBOutlet UIButton * bt_done;
@property (strong,nonatomic) IBOutlet UIButton * bt_cancel;
@property (strong,nonatomic) IBOutlet UIPickerView * pv_keys;

- (IBAction) act_cancel;
- (IBAction) act_done;
@end

NS_ASSUME_NONNULL_END
