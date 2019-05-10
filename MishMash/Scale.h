//
//  Scale.h
//  MishMash
//
//  Created by Henry Lowengard on 4/10/19.
//  Copyright © 2019 net.jhhl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Note.h"
#import "Consts.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScaleNode : NSObject
@property (strong,nullable) Note * note;
@property (strong,nullable) ScaleNode * down;
@property (strong,nullable) ScaleNode * up;
@end

@interface Scale : NSObject
@property (strong,nonatomic,nonnull) NSString * name;
@property (strong,nonatomic,nonnull) NSString * pattern;

@property double base; // a MIDI note.. might be microtonal at some point
// 
 
// resolved into dmidis
@property (strong,nonatomic,nonnull) ScaleNode * scaleNodeCursor;
@property (assign) ScaleNode * scaleNodeFirst; // first one made
@property (assign) ScaleNode * scaleNodeBaseNode; // what the center of the scale is

- (void) digestPattern: (NSString * _Nonnull) pattern base:(dmidi) base;
@end

NS_ASSUME_NONNULL_END
