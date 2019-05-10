//
//  Mishas.m
//  MishMash
//
//  Created by Henry Lowengard on 5/1/19.
//  Copyright © 2019 net.jhhl. All rights reserved.
//

#import "Mishas.h"

@implementation Mishas
static Mishas * instance;

//put other statics here for class variables

+ (void) initialize
{
    [super initialize];
}

+ (instancetype _Nonnull) _
{
    if(!instance)
    {
        instance = [[Mishas alloc] init];
    }
    return instance;
}
@end
