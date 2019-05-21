//
//  MIDIManager.h
//  MishMash
//
//  Created by Henry Lowengard on 5/1/19.
//  Copyright © 2019 net.jhhl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIKMIDI.h"
#import "Consts.h"
NS_ASSUME_NONNULL_BEGIN

@interface MIDIManager : NSObject
{
    NSUInteger currentlyPlayingNotes[MAX_POLYPHONY];
    NSUInteger playingNotesCount;
}
@property (strong,nonatomic,nullable)     MIKMIDIDevice * device;


+ (instancetype _Nonnull) _;

- (void) connectToMIDIDevice;
- (void) midiEnvChanged;

- (void) noteOnAndOff:(dmidi) note vel:(float) vel;
- (void) noteOn:(dmidi) note vel:(float) vel;
- (void) noteOff:(dmidi) note vel:(float) vel;

- (void) noteOnMono:(dmidi) note vel:(float) vel;
- (void) noteOffMono:(dmidi) note vel:(float) vel;
- (void) ANO;

@end

NS_ASSUME_NONNULL_END
