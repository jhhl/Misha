//
//  Mishas.h
//  MishMash
//
//  Created by Henry Lowengard on 5/1/19.
//  Copyright © 2019 net.jhhl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Misha.h"

NS_ASSUME_NONNULL_BEGIN

@interface Mishas : NSObject
@property (strong,nonatomic) NSMutableDictionary * mishas;
@property (strong,nonatomic) NSMutableArray * sortedKeys;
+ (instancetype _Nonnull) _;
@end

NS_ASSUME_NONNULL_END
