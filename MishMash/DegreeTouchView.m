//
//  DegreeTouchView.m
//  MishMash
//
//  Created by Henry Lowengard on 5/1/19.
//  Copyright © 2019 net.jhhl. All rights reserved.
//

#import "DegreeTouchView.h"
#import "Skins.h"
#import "Scales.h"


@implementation DegreeTouchView
- (void)initInnards
{
    // create the Degree buttons
    
    _degreeButtons = [[NSMutableArray alloc] initWithCapacity:DEGREE_BUTTON_RANGE*2+1];
    for(int i = -DEGREE_BUTTON_RANGE;i<=DEGREE_BUTTON_RANGE;i++)
    {
        DegreeButton * db  = [[DegreeButton alloc] init];
        db.lb_degree.text = [NSString stringWithFormat:@"%d", i];
        db.delegate = self;
        db.degree = i;
        [_degreeButtons addObject:db];
        [self addSubview:db];
    }
    // Pie!
    _spv_pie = [[ScalePieView alloc] init];
    [self addSubview:_spv_pie];
    // bender
    _ssl_bend = [[MishaSlider alloc] init];
    [self addSubview:_ssl_bend];
    
    [Skins afterChangingSkinDoThis:^(Skin * s)
     {
         self.backgroundColor = s.cl_bg_main;

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
//MARK: - Subviews
#define MIN_BUTTON_SIZE 100.0
#define MARGIN 4.0
#define TOP_CONTROL_HEIGHT 60.0
#define SLIDER_HEIGHT 30.0
- (void) layoutSubviews
{
    [super layoutSubviews];
    
    /* we will go with two on each side, five on the bottom for landscapes where there's room.
     if portratis and small, three onthe bottom, hrre on each side. */
    CGSize size = self.bounds.size;
    size.width = size.width-(self.safeAreaInsets.left+self.safeAreaInsets.right);
    size.height = size.height-(self.safeAreaInsets.top+self.safeAreaInsets.bottom);
    CGRect buttonFrameBase=CGRectZero;
    CGRect buttonFrameSide=CGRectZero;
    
    
    //landscape
    if(5*(MIN_BUTTON_SIZE+MARGIN) <size.width)
    {
        // room for 5
        /*
         
         0       8
         1       7
         2 3 4 5 6
         */
        buttonFrameBase.size.width = (((size.width-MARGIN)/5.0)-MARGIN);
        // if we know how big the cntral ting is, we can calc the heights too.
        // for now, go with 2/3
        buttonFrameBase.size.height =  (buttonFrameBase.size.width * 0.666);
        
        //sides will be similar???
        buttonFrameSide.size.width = buttonFrameBase.size.height;
        // 60 is the size of the top menu??
        buttonFrameSide.size.height = (size.height-(MARGIN+buttonFrameBase.size.height+MARGIN)) /(2.0) -MARGIN;
        
        // the side heights should be the same size as the ones on the base are , kind of.
        buttonFrameSide.size.height = MIN(buttonFrameSide.size.height, buttonFrameBase.size.width);

        // do the layout
        CGFloat left = MARGIN;
        CGFloat top = size.height-(MARGIN+buttonFrameBase.size.height);
        DegreeButton * db;
        for(int d=2;d<7;d++)
        {
            buttonFrameBase.origin.x=left;
            buttonFrameBase.origin.y=top;
            db= self.degreeButtons[d];
            db.frame = buttonFrameBase;
            left+= buttonFrameBase.size.width+MARGIN;
        }
        //
        top= (size.height-MARGIN-buttonFrameBase.size.height)-((MARGIN+ buttonFrameSide.size.height)*2);
        left = MARGIN;
        for(int d=0;d<2;d++)
        {
            buttonFrameSide.origin.x=left;
            buttonFrameSide.origin.y=top;
            db= self.degreeButtons[d];
            db.frame = buttonFrameSide;
            top+= buttonFrameSide.size.height+MARGIN;
        }
        
        top= (size.height-MARGIN-buttonFrameBase.size.height)-((MARGIN+ buttonFrameSide.size.height)*2);
        left = size.width-(MARGIN+buttonFrameSide.size.width);
        for(int d=8;d>=7;d--)
        {
            buttonFrameSide.origin.x=left;
            buttonFrameSide.origin.y=top;
            db= self.degreeButtons[d];
            db.frame = buttonFrameSide;
            top+= buttonFrameSide.size.height+MARGIN;
        }
    }
    else
    {
        // room for 3
        /*
         
         0   8
         1   7
         2   6
         3 4 5
         */
        buttonFrameBase.size.width = (((size.width-MARGIN)/3.0)-MARGIN);
        // if we know how big the cntral ting is, we can calc the heights too.
        // for now, go with 2/3
        buttonFrameBase.size.height =  (buttonFrameBase.size.width * 0.666);
        //sides will be similar???
        buttonFrameSide.size.width = buttonFrameBase.size.height;
        buttonFrameSide.size.height = (size.height-(MARGIN+buttonFrameBase.size.height+MARGIN)) /(3.0) -MARGIN;
        // the side heights should be the same size as the ones on the base are , kind of.
        buttonFrameSide.size.height = MIN(buttonFrameSide.size.height, buttonFrameBase.size.width);
        
        // do the layout
        CGFloat left = MARGIN;
        CGFloat top = size.height-(MARGIN+buttonFrameBase.size.height);
        DegreeButton * db;
        for(int d=3;d<6;d++)
        {
            buttonFrameBase.origin.x=left;
            buttonFrameBase.origin.y=top;
            db= self.degreeButtons[d];
            db.frame = buttonFrameBase;
            left+= buttonFrameBase.size.width+MARGIN;
        }
        
        top= (size.height-MARGIN-buttonFrameBase.size.height)-((MARGIN+ buttonFrameSide.size.height)*3);
        left = MARGIN;
        for(int d=0;d<3;d++)
        {
            buttonFrameSide.origin.x=left;
            buttonFrameSide.origin.y=top;
            db= self.degreeButtons[d];
            db.frame = buttonFrameSide;
            top+= buttonFrameSide.size.height+MARGIN;
        }
        
        top= (size.height-MARGIN-buttonFrameBase.size.height)-((MARGIN+ buttonFrameSide.size.height)*3);
        left = size.width-(MARGIN+buttonFrameSide.size.width);
        for(int d=8;d>=6;d--)
        {
            buttonFrameSide.origin.x=left;
            buttonFrameSide.origin.y=top;
            db= self.degreeButtons[d];
            db.frame = buttonFrameSide;
            top+= buttonFrameSide.size.height+MARGIN;
        }
        
    }
    // stick the pie and the slider inthere somehow
    CGFloat left = MARGIN+ buttonFrameSide.size.width + MARGIN;
    CGFloat top = MARGIN;
    CGFloat pieWidth = size.width - 2.0*(buttonFrameSide.size.width +MARGIN+MARGIN);
    CGFloat pieHeight = size.height - (buttonFrameBase.size.height +MARGIN+MARGIN)- SLIDER_HEIGHT-MARGIN-MARGIN;
   
    CGRect pFrame = CGRectMake(left,top,pieWidth,pieHeight);

    // add squaring logic here
    // square up that rect = smallifying
     if(pieWidth>pieHeight)
    {
        CGFloat wdiff =(pieWidth-pieHeight)/2.0;
        pFrame.size.width-=wdiff*2;
        pFrame.origin.x+=wdiff;
    }
    else
    {
        CGFloat hdiff =(pieHeight-pieWidth)/2.0;
        pFrame.size.height-=hdiff*2;
//        pFrame.origin.y+=hdiff;  // leave it at the top
    }
    
    _spv_pie.frame  = pFrame;
    
    // shove the slider .. somewhere
    _ssl_bend.frame  = CGRectMake(pFrame.origin.x,pFrame.origin.y+pFrame.size.height+MARGIN,
                                  pFrame.size.width,SLIDER_HEIGHT);
    
}

//MARK: - DegreeButtonDelegate
- (void) degreeButton:(DegreeButton *) button tappedAt:(CGPoint) p;
{
    [Scales._ next:button.degree];
    [_delegate dtviewChanged:self];
    [_spv_pie setNeedsDisplay];
}
- (void) degreeButton:(DegreeButton *) button uppedAt:(CGPoint) p;
{
    [_delegate  dtviewNoff:self];
    [_spv_pie setNeedsDisplay];
}
@end
