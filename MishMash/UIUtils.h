//
//  UIUtils.h
//  Fortuna
//
//  Created by Henry Lowengard on 9/24/17.
//  Copyright © 2017 Jhhl.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accelerate/Accelerate.h>

@interface UIUtils : NSObject
+ (NSAttributedString *) attributedStringWithString:(NSString *) text
                                              color:(UIColor *) textColor
                                          fontNamed:(NSString *) fontName
                                           fontSize:(float) fontSize
                                          alignment: (CTTextAlignment) theAlignment // kCTCenterTextAlignment
;
void CGContextShowNSStringInRectRSU(CGContextRef context,CGSize parentSize,CGRect textRect,NSString * text,float fontSize,UIColor * fontColor)
;
void CGContextShowNSAStringInRectRSU(CGContextRef context,CGSize parentSize,CGRect textRect,NSAttributedString * text)
;
void CGContextShowNSStringInRectRSUfs(CGContextRef context,CGSize parentSize,CGRect textRect,NSString * text,float fontSize, UIColor * textColor, UIColor * edgeColor)
;
// MARK: vibs
void fillRectInBitmapWithColor(vImage_Buffer * vib,
                               CGRect r,
                               Pixel_8 * icomps);
void mergeRectInBitmapWithColor(vImage_Buffer * vib,
                                   CGRect r,
                                   Pixel_8 * icomps);
void vibFromUIImage(UIImage * image,vImage_Buffer * tvib);
+ (CGImageRef ) cgImageFromVib: (vImage_Buffer *) ivib;

@end
