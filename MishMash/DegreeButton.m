//
//  DegreeButton.m
//  MishMash
//
//  Created by Henry Lowengard on 4/12/19.
//  Copyright © 2019 net.jhhl. All rights reserved.
//

#import "DegreeButton.h"
#import "Skins.h"

@implementation DegreeButton
- (void)initInnards
{
    _lb_degree =[[UILabel alloc] init];
    [self addSubview:_lb_degree];
    [Skins afterChangingSkinDoThis:^(Skin * s)
     {
         self.backgroundColor = s.cl_lo;
         self.tintColor = s.cl_hi_text;
         self.lb_degree.tintColor =s.cl_hi_text;
     }];
}
// good old init
- (instancetype)initWithFrame:(CGRect) frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initInnards];
    }
    return self;
}
// for nibs
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initInnards];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#define LB_WIDTH 30
#define LB_HEIGHT 30
- (void) layoutSubviews
{
    [super layoutSubviews];
    CGSize selfSize = self.bounds.size;
 
    CGRect lbframe = CGRectMake((selfSize.width-LB_WIDTH)/2.0,
                                (selfSize.height-LB_HEIGHT)/2.0,
                                LB_WIDTH,
                                LB_HEIGHT);
    _lb_degree.frame = lbframe;
}
#pragma mark - Touches

typedef enum {TOUCH_BEGAN,TOUCH_MOVED,TOUCH_ENDED,TOUCH_CANCEL} TouchState;

- (void) processTouch:(UITouch *) touch state:(TouchState) state
{
    if(state ==0)
    {
        self.backgroundColor = Skins._.currentSkin.cl_hi;
        // we'll get the actual touch point if we need it later
        [_delegate degreeButton:self tappedAt:CGPointMake(0.0,0.0)];
    }
    if(state ==1)
    {
        // movement....
         // we'll get the actual touch point if we need it later it might be relative
//        [_delegate degreeButton:self tappedAt:CGPointMake(0.0,0.0)];
    }
    
    if(state ==2)
    {
        self.backgroundColor = Skins._.currentSkin.cl_lo;
        [_delegate degreeButton:self uppedAt:CGPointMake(0.0,0.0)];

    }
    if(state ==3)
    {
        self.backgroundColor = Skins._.currentSkin.cl_lo;
        [_delegate degreeButton:self uppedAt:CGPointMake(0.0,0.0)];
    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for(UITouch * touch in touches)
    {
        [self processTouch:touch state:TOUCH_BEGAN];
    }
};

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for(UITouch * touch in touches)
    {
        [self processTouch:touch state:TOUCH_MOVED];
    }
};


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for(UITouch * touch in touches)
    {
        [self processTouch:touch state:TOUCH_ENDED];
    }
};

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    for(UITouch * touch in touches)
    {
        [self processTouch:touch state:TOUCH_ENDED];
    }
};

@end
