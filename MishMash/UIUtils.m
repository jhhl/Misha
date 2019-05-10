//
//  UIUtils.m
//  Fortuna
//
//  Created by Henry Lowengard on 9/24/17.
//  Copyright © 2017 Jhhl.net. All rights reserved.
//

#import "UIUtils.h"
#import <CoreText/CoreText.h>
#import "UIColor+HTML.h"

@implementation UIUtils


+ (NSAttributedString *) attributedStringWithString:(NSString *) text
                                              color:(UIColor *) textColor
                                          fontNamed:(NSString *) fontName
                                           fontSize:(float) fontSize
                                          alignment: (CTTextAlignment) theAlignment // kCTCenterTextAlignment
{
    
    // now entering the world of CoreText
    CGColorRef color = textColor.CGColor;
    CTFontRef font = CTFontCreateWithName((CFStringRef)fontName, fontSize, nil);
    
    CFIndex theNumberOfSettings = 1;
    // hmm said [1]
    //CTLineBreakMode wordWrapper=kCTLineBreakByWordWrapping; // this didn't fix the crash.
    CTParagraphStyleSetting theSettings[1] =
    {
        { kCTParagraphStyleSpecifierAlignment, sizeof(CTTextAlignment), &theAlignment },
        // { kCTParagraphStyleSpecifierLineBreakMode, sizeof(CTLineBreakMode), &wordWrapper }
    };
    
    
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(theSettings, theNumberOfSettings);
    
    NSDictionary *attributesDict = @{
                                     (NSString *)kCTFontAttributeName: (__bridge id)(font),
                                     (NSString *)kCTForegroundColorAttributeName: (__bridge id)color,
                                     (NSString *) kCTParagraphStyleAttributeName: (__bridge id)(paragraphStyle)
                                     };
    // possibly release these ...
    CFRelease(font);
    CFRelease(paragraphStyle);
    
    return [[NSAttributedString alloc]  initWithString:text attributes:attributesDict] ;
    
}

void CGContextShowNSAStringInRectRSU(CGContextRef context,CGSize parentSize,CGRect textRect,NSAttributedString * attString)
{
    
    // push context
    CGContextSaveGState(context);
    
    // Flip the coordinate system
    
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    
    CGContextTranslateCTM(context, 0, parentSize.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGMutablePathRef path = CGPathCreateMutable();
    /* this used to work OK.... but not if autosizing and centering...
     CGRect flipTextRect = textRect;
     flipTextRect.origin.y = parentSize.height - (flipTextRect.origin.y+flipTextRect.size.height);
     CGPathAddRect(path, NULL, flipTextRect );
     
     */
    
    // set text vertical alignment
    NSDictionary * attrDict = [attString attributesAtIndex:0 effectiveRange:NULL];
    
    
    CGSize textSize;
    
    //   UIFont * F= [UIFont boldSystemFontOfSize: 60.0];
    
    NSDictionary *smallAttributesDict = @{
                                          (NSString *)kCTFontAttributeName:  (NSString *) attrDict[(NSString *) NSFontAttributeName]
                                          };
    textSize = [attString.string  boundingRectWithSize:textRect.size
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:smallAttributesDict
                                               context:NULL ].size;
    CGPathAddRect(path, NULL, CGRectMake(textRect.origin.x, textRect.origin.y-(textRect.size.height-textSize.height)/2.0f, textRect.size.width, textRect.size.height));
    
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter,  CFRangeMake(0, [attString length]), path, NULL);
    
    CTFrameDraw(frame, context);
    
    CFRelease(frame); //5
    CFRelease(path);
    CFRelease(framesetter);
    
    CGContextRestoreGState(context);
}


void CGContextShowNSStringInRectRSU(CGContextRef context,CGSize parentSize,CGRect textRect,NSString * text,float fontSize,UIColor * fontColor)
{
#if 1
    NSMutableParagraphStyle *  paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.alignment  = NSTextAlignmentCenter;
    NSDictionary * attributes = @{
                                  NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size: fontSize],
                                  NSForegroundColorAttributeName:fontColor,
                                  NSParagraphStyleAttributeName: paragraphStyle
                                  };
    [text drawInRect:textRect withAttributes:attributes];
    
#else
    
    NSAttributedString * attString = [Globals attributedStringWithString:text color:[UIColor blackColor] fontNamed:@"Helvetica" fontSize:24.0 alignment:kCTCenterTextAlignment];
    CGContextShowNSAStringInRectRSU(context,parentSize,textRect,attString);
#endif
}

void CGContextShowNSStringInRectRSUfs(CGContextRef context,CGSize parentSize,CGRect textRect,NSString * text,float fontSize, UIColor * textColor, UIColor * edgeColor)
{
    CGContextSaveGState(context);

#define PUT_BOX_ON_IT 0
#if PUT_BOX_ON_IT
    CGContextSaveGState(context);
    CGContextSetStrokeColorWithColor(context,[UIColor redColor].CGColor);
    CGContextSetFillColorWithColor(context,[UIColor whiteColor].CGColor);
    CGContextFillRect(context, textRect);
    CGContextStrokeRect(context, textRect);
    CGContextRestoreGState(context);
#endif
    // try this old trick
    //  attString = [Globals attributedStringWithString:text color:[UIColor whiteColor] fontNamed:@"Helvetica" fontSize:fontSize alignment:kCTCenterTextAlignment];
    for(int u =-1;u<2;u++)
        for(int v = -1;v<2;v++)
        {
            if(u==0 && v==0)
                continue;
            
            CGRect wiggle = textRect;
            wiggle.origin.x+=u;
            wiggle.origin.y+=v;
            // CGContextShowNSAStringInRectRSU(context,parentSize,wiggle,attString);
            CGContextSetFillColorWithColor(context, edgeColor.CGColor);
            CGContextShowNSStringInRectRSU(context,parentSize,wiggle,text,fontSize,edgeColor);
        }
    
    // attString = [Globals attributedStringWithString:text color:[UIColor blackColor] fontNamed:@"Helvetica" fontSize:fontSize alignment:kCTCenterTextAlignment];
    //  CGContextShowNSAStringInRectRSU(context,parentSize,textRect,attString);
    
    CGContextShowNSStringInRectRSU(context,parentSize,textRect,text,fontSize,textColor);
    CGContextRestoreGState(context);

}
/*
 intersects line a-b and c-d returning point r.. and "factor" f
 if colinear or otherwise complicated , this will return NO
 */
void fillRectInBitmapWithCFFColor(vImage_Buffer * vib,
                                  CGRect r,
                                  CGFloat * components)
{
    
    Pixel_8 icomps[4];
    icomps[0] = components[0]*255;
    icomps[1] = components[1]*255;
    icomps[2] = components[2]*255;
    icomps[3] = components[3]*255;
    
    fillRectInBitmapWithColor( vib,
                              r,
                              icomps);
}

// we can gen the lookup map as Pixel_8s . we can even probably make a CLUT context.
void fillRectInBitmapWithColor(vImage_Buffer * vib,
                               CGRect r,
                               Pixel_8 * icomps)
{
    // might need scale
    int iX=MAX(1,r.origin.x);
    int iY=r.origin.y;
    int iH= r.size.height;
    int iW=r.size.width;
    Pixel_8 * sid = vib->data;
    // not sure why this is running backwards.
    for(int ixh=iY;ixh<iY+iH;ixh++)
    {
        if(ixh<vib->height)
        {
            // run this from the top?
            NSUInteger base = (ixh)*vib->rowBytes;
            // why isn't this 0 based?
            for(int ixw=iX-1;ixw<iX+iW;ixw++)
            {
                NSUInteger coord = base + (4*sizeof(Pixel_8) * ixw);
                sid[coord+0]=icomps[0];
                sid[coord+1]=icomps[1];
                sid[coord+2]=icomps[2];
                sid[coord+3]=icomps[3];
            }
        }
    }
}

 void mergeRectInBitmapWithColor(vImage_Buffer * vib,
                                   CGRect r,
                                   Pixel_8 * icomps)
    {
        // might need scale
        int iX=MAX(1,r.origin.x);
        int iY=r.origin.y;
        int iH= r.size.height;
        int iW=r.size.width;
        Pixel_8 * sid = vib->data;
        // not sure why this is running backwards.
        Pixel_8 scaled[4];
        
        scaled[0] = icomps[0]/4;
        scaled[1] = icomps[1]/4;
        scaled[2] = icomps[2]/4;
        for(int ixh=iY;ixh<iY+iH;ixh++)
        {
            // run this from the top?
            NSUInteger base = (ixh)*vib->rowBytes;
            // why isn't this 0 based?
            for(int ixw=iX-1;ixw<iX+iW;ixw++)
            {
                NSUInteger coord = base + (4*sizeof(Pixel_8) * ixw);
                sid[coord+0]=sid[coord+0]*3/4 + scaled[0];
                sid[coord+1]=sid[coord+0]*3/4 + scaled[1];
                sid[coord+2]=sid[coord+0]*3/4 + scaled[2];
                sid[coord+3]=255;
            }
        }
    }
/**
 fills vib with UIImageData and pointers!


 @param image UIImage in
 @param tvib Tvib out
 */
void vibFromUIImage(UIImage * image,vImage_Buffer * tvib)
{
    //Get CGImage from UIImage
    CGImageRef img = image.CGImage;
//    vImage_Buffer  *tvib =malloc(sizeof(vImage_Buffer));
    CGFloat backGroundComps[4]={0.0,0.0,0.0,1.0};
    vImage_CGImageFormat format ;
    format.bitsPerComponent=(uint32_t)CGImageGetBitsPerComponent(img);
    format.bitsPerPixel=(uint32_t)CGImageGetBitsPerPixel(img);
    format.colorSpace=CGImageGetColorSpace(img);
    format.bitmapInfo=kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst; //CGImageGetBitmapInfo(img);
    format.version=0;
    format.decode=CGImageGetDecode(img);
    format.renderingIntent=CGImageGetRenderingIntent(img);
    vImageBuffer_InitWithCGImage(tvib, &format, backGroundComps, img, 0);
}


+ (UIImage * ) uiImageFromVib: (vImage_Buffer *) ivib orientation: (UIImageOrientation) uiio
{
    CGImageRef cgir = [self cgImageFromVib:ivib];
    UIImage * image =[UIImage imageWithCGImage:cgir scale:1.0 orientation:uiio];
    CGImageRelease(cgir);
    return image;
}


+ (CGImageRef ) cgImageFromVib: (vImage_Buffer *) ivib
{
    /*CG_EXTERN CGContextRef CGBitmapContextCreate(
     void *data,
     size_t width,
     size_t height,
     size_t bitsPerComponent,
     size_t bytesPerRow,
     CGColorSpaceRef space,
     CGBitmapInfo bitmapInfo);
     
     16  bits per pixel,         5  bits per component,         kCGImageAlphaNoneSkipFirst
     
     32  bits per pixel,         8  bits per component,         kCGImageAlphaNoneSkipFirst very blue
     32  bits per pixel,         8  bits per component,         kCGImageAlphaNoneSkipLast kind of blue
     32  bits per pixel,         8  bits per component,         kCGImageAlphaPremultipliedFirst inside out
     32  bits per pixel,         8  bits per component,         kCGImageAlphaPremultipliedLast kind of blue
     
     64  bits per pixel,         16 bits per component,         kCGImageAlphaPremultipliedLast
     64  bits per pixel,         16 bits per component,         kCGImageAlphaNoneSkipLast
     64  bits per pixel,         16 bits per component,         kCGImageAlphaPremultipliedLast|kCGBitmapFloatComponents
     64  bits per pixel,         16 bits per component,         kCGImageAlphaNoneSkipLast|kCGBitmapFloatComponents
     128 bits per pixel,         32 bits per component,         kCGImageAlphaPremultipliedLast|kCGBitmapFloatComponents
     128 bits per pixel,         32 bits per component,         kCGImageAlphaNoneSkipLast|kCGBitmapFloatComponents
     
     */
    CGContextRef newContext;
    CGColorSpaceRef colorSpace;
    if(ivib->rowBytes == ivib->width)
    {
        colorSpace = CGColorSpaceCreateDeviceGray();
        newContext = CGBitmapContextCreate(ivib->data,
                                           ivib->width,
                                           ivib->height,
                                           8,
                                           ivib->rowBytes,
                                           colorSpace,
                                           kCGImageAlphaNone /*kCGBitmapByteOrderDefault */ );
    }
    else
    {
        colorSpace = CGColorSpaceCreateDeviceRGB();
        newContext = CGBitmapContextCreate(ivib->data,
                                           ivib->width,
                                           ivib->height,
                                           8,
                                           ivib->rowBytes,
                                           colorSpace,
                                           kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst
                                           );
        
    };
    if(!newContext)
    {
        NSLog(@"DANGER! 0 context??");
        CGContextRelease(newContext);
        CGColorSpaceRelease(colorSpace);
        return NULL;
    }
    CGImageRef newImage = CGBitmapContextCreateImage(newContext);
    CGContextRelease(newContext);
    CGColorSpaceRelease(colorSpace);
    
    return newImage;
}

@end
