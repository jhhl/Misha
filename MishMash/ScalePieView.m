//
//  ScalePieView.m
//  MishMash
//
//  Created by Henry Lowengard on 4/12/19.
//  Copyright © 2019 net.jhhl. All rights reserved.
// should just show the scale withthe base at the top, octave dots below.
// it may have buttons available in the corners
// or they may belong to the main VC
//
#import "ScalePieView.h"
#import "Skins.h"
#import "Scales.h"
#import "DegreeTouchView.h"
#import "UIUtils.h"

@interface ScalePieView()
{
    CGColorRef _cgcr_bg;
}
@end

@implementation ScalePieView
- (void)initInnards
{
    [Skins  afterChangingSkinDoThis:^(Skin * sk)
     {
         self.backgroundColor = sk.cl_lo;
         self.tintColor = sk.cl_hi_text;
         if(self->_cgcr_bg)
         {
             CGColorRelease(self->_cgcr_bg);
         }
         self->_cgcr_bg = CGColorRetain(sk.cl_hi.CGColor);
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

// I think my tone spiral version would be better. 
- (void)drawRect:(CGRect)rect {
    // Drawing code
    // as RTScale what the scale is now. in the range of +/-DEGREE_BUTTON_RANGE
    Scales * S_ = Scales._;
     NSMutableArray * degrees= [[NSMutableArray alloc] init];
    for(NSInteger i = -DEGREE_BUTTON_RANGE;i<DEGREE_BUTTON_RANGE+1;i++)
    {
        ScaleNode * n =[S_ whatIsAt:i];
        if(n)
        {
            [degrees addObject:n];
        }
    }
    float angle = 2.0*M_PI/(degrees.count);
    
    // ok draw something
//    float scale = 1.0;
    CGRect sqRect = rect; // should be square due to layout.
    CGPoint center = CGPointMake(sqRect.origin.x+sqRect.size.width/2.0,sqRect.origin.y+sqRect.size.height/2.0);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetShouldAntialias(ctx, YES);
    
    
    CGColorSpaceRef cgCSRef = CGColorSpaceCreateDeviceRGB();
    CGContextSetFillColorSpace (ctx,cgCSRef);
    CGContextSetStrokeColorSpace (ctx,cgCSRef);
    CGColorSpaceRelease(cgCSRef);
    // clear
    CGContextSetFillColorWithColor(ctx,_cgcr_bg);
  
    CGContextFillEllipseInRect(ctx, sqRect);
    // in out
    CGContextSetLineWidth(ctx,2.0);
    
    
    float currAngle = 0;
    float ang2 = angle/2.0;

    float rad =sqRect.size.height/2.0;
    float rad2 = rad*0.75;
    UIColor * textColor = Skins._.currentSkin.cl_hi_text;
//    UIColor * edgeColor = Skins._.currentSkin.cl_lo_text;

    for(int i=0;i<degrees.count;i++)
    {
        CGPoint edge = CGPointMake(center.x+rad*-sin(currAngle),
                                   center.y+rad*cos(currAngle));
        CGContextMoveToPoint(ctx, center.x, center.y);
        CGContextAddLineToPoint(ctx, edge.x, edge.y);
        CGContextDrawPath(ctx, kCGPathStroke);
        CGRect textRect = CGRectMake(center.x+rad2*-sin(currAngle+ang2)-15.0,
                                     center.y+rad2*cos(currAngle+ang2)-15.0,
                                     30.0,
                                     30.0);

        ScaleNode * nn = degrees[i];
        // was fs, no real need for the edging.
         CGContextShowNSStringInRectRSU(ctx,
                                          rect.size,
                                          textRect,
                                          nn.note.name,
                                          18.0,
                                            textColor);
        currAngle+=angle;
    }
}


@end
