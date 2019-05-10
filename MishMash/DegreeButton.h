//
//  DegreeButton.h
//  MishMash
//
//  Created by Henry Lowengard on 4/12/19.
//  Copyright © 2019 net.jhhl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Skin.h"

NS_ASSUME_NONNULL_BEGIN

@class DegreeButton;

@protocol DegreeButtonDelegate
- (void) degreeButton:(DegreeButton *) button tappedAt:(CGPoint) p;
- (void) degreeButton:(DegreeButton *) button uppedAt:(CGPoint) p;
@end

@interface DegreeButton : UIView
IB_DESIGNABLE
@property (assign) id<DegreeButtonDelegate> delegate;

@property NSInteger degree;
@property (strong,nonatomic,nonnull)   UILabel * lb_degree;

@end

NS_ASSUME_NONNULL_END
