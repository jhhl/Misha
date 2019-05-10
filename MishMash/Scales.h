//
//  RTScale.h
//  MishMash
//
//  Created by Henry Lowengard on 5/1/19.
//  Copyright © 2019 net.jhhl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Scale.h"

NS_ASSUME_NONNULL_BEGIN

@interface Scales : NSObject

@property (strong,nonatomic) NSMutableDictionary * scales;
@property (strong,nonatomic) NSMutableArray * sortedKeys;

@property (assign) Scale * scale;
@property (assign) ScaleNode * cursor;

+ (instancetype _Nonnull) _;

-(ScaleNode * _Nullable) next:(NSInteger) step; // sets cursor
-(ScaleNode * _Nullable) whatIsAt:(NSInteger) step;

@end

NS_ASSUME_NONNULL_END
