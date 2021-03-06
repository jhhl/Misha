//
//  MIDIManager.m
//  MishMash
//
//  Created by Henry Lowengard on 5/1/19.
//  Copyright © 2019 net.jhhl. All rights reserved.
//

#import "MIDIManager.h"

@implementation MIDIManager

#define NOTE_EMPTY 1000

static MIDIManager * instance;

//put other statics here for class variables

+ (void) initialize
{
    [super initialize];
}

+ (instancetype _Nonnull) _
{
    if(!instance)
    {
        instance = [[MIDIManager alloc] init];
    }
    return instance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        // will be more sophisticated.
        [self connectToMIDIDevice];
        [self listenForMIDIChanges];
        playingNotesCount=0;
    }
    return self;
}

- (void) listenForMIDIChanges
{
    NSNotificationCenter * N = [NSNotificationCenter defaultCenter];
    NSArray * notifys = @[
                        MIKMIDIDeviceWasAddedNotification,
                        MIKMIDIDeviceWasRemovedNotification,
                        MIKMIDIVirtualEndpointWasAddedNotification,
                        MIKMIDIVirtualEndpointWasRemovedNotification
                        ];
    for(NSString * notify in notifys)
    {
        [N addObserverForName:notify object:NULL queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * n)
         {
             [self midiEnvChanged];
         }];
    }
  
}
- (void) midiEnvChanged
{
    [self connectToMIDIDevice];
}

- (void) connectToMIDIDevice
{
    NSArray *availableMIDIDevices = [[MIKMIDIDeviceManager sharedDeviceManager] availableDevices];
    // be smarter about this. 
    self.device =[availableMIDIDevices lastObject];
    
    NSArray *sources = [self.device.entities valueForKeyPath:@"@unionOfArrays.sources"];
    MIKMIDISourceEndpoint * source = [sources firstObject]; // Or whichever source you want, but often there's only one.
    
    // Next, connect to that source using MIKMIDIDeviceManager:
    
    MIKMIDIDeviceManager *manager = [MIKMIDIDeviceManager sharedDeviceManager];
    NSError *error = nil;
    
    BOOL success = [manager connectInput:source error:&error eventHandler:^(MIKMIDISourceEndpoint *source, NSArray *commands) {
        for (MIKMIDICommand *command in commands) {
            // Handle each command
            // looks like incoming MIDI commands here ..
            NSLog(@"%@",command);
        }
    }];
    if (!success) {
        NSLog(@"Unable to connect to %@: %@", source, error);
        // Handle the error
    }
    
    // virtualDestinations
//    allDests = [self.device.entities valueForKeyPath:@"@unionOfArrays.destinations"];
    allDests = [[MIKMIDIDeviceManager sharedDeviceManager] virtualDestinations] ;
    destinationEndpoint = [allDests firstObject]; // Or whichever source you want, but often there's only one.
}

//MARK: - commands
// this is going to ge samrter vis-a-vis destinations and other messages
- (void) noteOnAndOff:(dmidi) note vel:(float) vel
{
    NSError *error = nil;
    
    NSDate *date = [NSDate date];
    NSUInteger mNote = MAX(0.0,MIN(127,floor(note+0.5)));
    NSUInteger mVel = MAX(0.0,MIN(127,vel * 127.0));
    MIKMIDINoteOnCommand *noteOn = [MIKMIDINoteOnCommand noteOnCommandWithNote:mNote velocity:mVel channel:0 timestamp:date];
    [self insert:mNote];
    
    MIKMIDINoteOffCommand *noteOff = [MIKMIDINoteOffCommand noteOffCommandWithNote:mNote velocity:0 channel:0 timestamp:[date dateByAddingTimeInterval:0.5]];
    
    MIKMIDIDeviceManager *dm = [MIKMIDIDeviceManager sharedDeviceManager];
    for(MIKMIDIDestinationEndpoint * desty in allDests)
    {
        [dm sendCommands:@[noteOn, noteOff] toEndpoint:desty error:&error];
    }
}

- (void) noteOn:(dmidi) note vel:(float) vel
{
    NSError *error = nil;
    
    NSDate *date = [NSDate date];
    NSUInteger mNote = MAX(0.0,MIN(127,floor(note+0.5)));
    NSUInteger mVel = MAX(0.0,MIN(127,vel * 127.0));
    MIKMIDINoteOnCommand *noteOn = [MIKMIDINoteOnCommand noteOnCommandWithNote:mNote velocity:mVel channel:0 timestamp:date];
    
    MIKMIDIDeviceManager *dm = [MIKMIDIDeviceManager sharedDeviceManager];
    for(MIKMIDIDestinationEndpoint * desty in allDests)
    {
        [dm sendCommands:@[noteOn] toEndpoint:desty error:&error];
    }
    [self insert:mNote];
}

- (void) noteOff:(dmidi) note vel:(float) vel
{
    NSError *error = nil;
    NSDate *date = [NSDate date];
    NSUInteger mNote = MAX(0.0,MIN(127,floor(note+0.5)));
    NSUInteger mVel = MAX(0.0,MIN(127,vel * 127.0));
    MIKMIDINoteOffCommand *noteOff = [MIKMIDINoteOffCommand noteOffCommandWithNote:mNote velocity:mVel channel:0 timestamp:date];
    
    MIKMIDIDeviceManager *dm = [MIKMIDIDeviceManager sharedDeviceManager];
    for(MIKMIDIDestinationEndpoint * desty in allDests)
    {
        [dm sendCommands:@[noteOff] toEndpoint:desty error:&error];
    }
}
 // lastNoteOn
- (void) noteOnMono:(dmidi) note vel:(float) vel
{
    NSError *error = nil;
    
    NSDate *date = [NSDate date];
    
    NSUInteger mNote = MAX(0.0,MIN(127,floor(note+0.5)));
    NSUInteger mVel = MAX(0.0,MIN(127,vel * 127.0));
    
    NSMutableArray * ma_data = [[NSMutableArray alloc] init];
    if(playingNotesCount>0)
    {
        for(int i =0;i<playingNotesCount;i++)
        {
            if(currentlyPlayingNotes[i]!= NOTE_EMPTY)
            {
                NSUInteger noffMe =currentlyPlayingNotes[i];
                MIKMIDINoteOffCommand *noteOff = [MIKMIDINoteOffCommand noteOffCommandWithNote:noffMe velocity:mVel channel:0 timestamp:date];
                [ma_data addObject:noteOff];
            }
        }
        [self removeAll];
     }
    
    // make thiss after the noteoff
    MIKMIDINoteOnCommand *noteOn = [MIKMIDINoteOnCommand noteOnCommandWithNote:mNote velocity:mVel channel:0 timestamp:[date dateByAddingTimeInterval:0.01]];
    [self insert:mNote];
     [ma_data addObject:noteOn];
    
    MIKMIDIDeviceManager *dm = [MIKMIDIDeviceManager sharedDeviceManager];
    for(MIKMIDIDestinationEndpoint * desty in allDests)
    {
        [dm sendCommands:ma_data toEndpoint:desty error:&error];
        if(error)
        {
            NSLog(@"NON error %@",error);
        }
    }
    ma_data=NULL;
}

- (void) noteOffMono:(dmidi) note vel:(float) vel
{
    NSError *error = nil;
    NSDate *date = [NSDate date];
    NSUInteger mNote = MAX(0.0,MIN(127,floor(note+0.5)));
    NSUInteger mVel = MAX(0.0,MIN(127,vel * 127.0));
    MIKMIDINoteOffCommand *noteOff = [MIKMIDINoteOffCommand noteOffCommandWithNote:mNote velocity:mVel channel:0 timestamp:date];
    
    MIKMIDIDeviceManager *dm = [MIKMIDIDeviceManager sharedDeviceManager];
    for(MIKMIDIDestinationEndpoint * desty in allDests)
    {
        [dm sendCommands:@[noteOff] toEndpoint:desty error:&error];
    }
    [self remove:mNote];
}

- (void) ANO
{
    NSError *error = nil;
//    NSDate *date = [NSDate date];
    
    MIKMIDIControlChangeCommand *ano = [MIKMIDIControlChangeCommand controlChangeCommandWithControllerNumber: 123 value:0];

    MIKMIDIDeviceManager *dm = [MIKMIDIDeviceManager sharedDeviceManager];
    for(MIKMIDIDestinationEndpoint * desty in allDests)
    {
        [dm sendCommands:@[ano] toEndpoint:desty error:&error];
        
        // of fooey sometimes you need to send everything
        for(int noff = 0 ; noff<128;noff++)
        {
            NSDate *date = [NSDate date];
            
            MIKMIDINoteOffCommand *noteOff = [MIKMIDINoteOffCommand noteOffCommandWithNote:noff velocity:0 channel:0 timestamp:date];
            [dm sendCommands:@[noteOff] toEndpoint:desty error:&error];
        }
    }
    [self removeAll];
}

//MARK: push, pop, etc

-(void) insert:(NSUInteger) v
{
    currentlyPlayingNotes[ playingNotesCount]=v;
    playingNotesCount++;
}

// efficient kind of trim.
-(void) remove:(NSUInteger) v
{
    if(playingNotesCount>0)
    {
        for(int i = 0;i<playingNotesCount;i++)
        {
            if(currentlyPlayingNotes[i]==v)
            {
                currentlyPlayingNotes[i]=NOTE_EMPTY;
            }
        }
        while((playingNotesCount>0) && (currentlyPlayingNotes[ playingNotesCount-1]==NOTE_EMPTY))
        {
            playingNotesCount-=1;
        }
    }
}
-(void) removeAll
{
    playingNotesCount=0;
}
@end
