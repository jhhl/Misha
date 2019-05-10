//
//  MIDIController.h
//  MishMash
//
//  Created by Henry Lowengard on 5/1/19.
//  Copyright © 2019 net.jhhl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UILabeledButton.h"
#import "UISkinnedSegmentedControl.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIDIViewController : UIViewController
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UIPickerViewDelegate
>
@property (strong,nonatomic) IBOutlet UILabeledButton * bt_done;
@property (strong,nonatomic) IBOutlet UILabeledButton * bt_cancel;

@property (strong,nonatomic) IBOutlet UISkinnedSegmentedControl * ssg_channels;
@property (strong,nonatomic) IBOutlet UIPickerView * pv_programs;

//for each device .. device: endpoint
@property (strong,nonatomic) IBOutlet UICollectionView * cv_sources; // for learning
@property (strong,nonatomic) IBOutlet UICollectionView * cv_dests;


- (IBAction) act_cancel;
- (IBAction) act_done;
@end

NS_ASSUME_NONNULL_END
