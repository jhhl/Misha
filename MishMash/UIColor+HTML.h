//
//  UIColor+HTML.h
//  CoreTextExtensions
//
//  Created by Oliver Drobnik on 1/9/11.
//  Copyright 2011 Drobnik.com. All rights reserved.
//
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (HTML)

+ (UIColor *)colorWithHexString:(NSString *)hex;
+ (UIColor *)colorWithHTMLName:(NSString *)name;
+ (NSArray *) arrayOfN:(int) n colorsFrom:(UIColor *) fromColor to:(UIColor * ) toColor;

- (CGFloat)alpha;
- (UIColor *)invertedColor;
- (UIColor * _Nonnull)zapAlpha:(CGFloat) alpha;
- (UIColor *)darkenBy:(CGFloat) darkness;

- (NSString *)htmlHexString;

NS_ASSUME_NONNULL_END

@end
