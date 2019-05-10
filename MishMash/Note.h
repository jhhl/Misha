//
//  Note.h
//  MishMash
//
//  Created by Henry Lowengard on 4/10/19.
//  Copyright © 2019 net.jhhl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Consts.h"
#import "MIKMIDIUtilities.h"

NS_ASSUME_NONNULL_BEGIN

@interface Note : NSObject
@property dmidi dmidi;
@property double hz; // might not need this
- (NSString * ) name;
@end

NS_ASSUME_NONNULL_END
