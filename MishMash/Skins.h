//
//  Skins.h
//  MishMash
//
//  Created by Henry Lowengard on 4/12/19.
//  Copyright © 2019 net.jhhl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Skin.h"

NS_ASSUME_NONNULL_BEGIN

@interface Skins : NSObject
@property (strong,nonatomic,nonnull) NSMutableDictionary<NSString *,Skin *> * skins;
@property (strong,nonatomic) NSMutableArray * sortedKeys;

@property (assign,nullable)  Skin * currentSkin;

+ (instancetype _Nonnull) _;

+ (id) afterChangingSkinDoThis:(void (^ _Nullable)(Skin * s))action;
- (void) setSkinToPresetNamed:(NSString *) pname;

@end

NS_ASSUME_NONNULL_END
