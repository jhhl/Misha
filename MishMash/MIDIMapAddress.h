//
//  MIDILearnAddress.h
//  MishMash
//
//  Created by Henry Lowengard on 5/6/19.
//  Copyright © 2019 net.jhhl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MIDIMapAddress : NSObject
@property  NSUInteger mappedMidiCommand;
@property  NSUInteger mappedMidiData;
- (NSString * ) midiString;
@end

NS_ASSUME_NONNULL_END
