//
//  MIDIManager.m
//  MishMash
//
//  Created by Henry Lowengard on 5/1/19.
//  Copyright © 2019 net.jhhl. All rights reserved.
//

#import "MIDIManager.h"

#define LOG_MIDI_IO 1

@interface MIDIManager()
{
    NSMutableSet * allSources;
    NSMutableSet * allDestinations;
}
@end

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
        allSources  =[[NSMutableSet alloc] init];
        allDestinations  =[[NSMutableSet alloc] init];
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
    [self establishDevicesAndEndpoints];
    // picking them is a different process, but  by default, pick something?
    // this logic has to be more like PolyHarp's.
    [self pickSourceNamed:@"Network Session 1" enable:YES];
    
}

- (void) establishDevicesAndEndpoints
{
    MIKMIDIDeviceManager *manager = [MIKMIDIDeviceManager sharedDeviceManager];
    NSArray *availableMIDIDevices = [manager availableDevices];
    // be smarter about this.
    
    [allSources removeAllObjects];
    [allDestinations  removeAllObjects];

    for(MIKMIDIDevice * device in availableMIDIDevices)
    {
        [allSources addObjectsFromArray:  [device.entities valueForKeyPath:@"@unionOfArrays.sources"]];
        [allDestinations addObjectsFromArray:  [self.device.entities valueForKeyPath:@"@unionOfArrays.destinations"]];
    }
         [allDestinations addObjectsFromArray:[manager virtualDestinations] ];
}

- (void) pickSourceNamed:(NSString *) name enable:(BOOL) enable
{
    MIKMIDIDeviceManager *manager = [MIKMIDIDeviceManager sharedDeviceManager];
    NSError *error = nil;
    for(MIKMIDISourceEndpoint * source in allSources.allObjects)
    {
        if([source.name isEqual:name])
        {
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
        } //matches
    }
}

- (void) pickDestinationNamed:(NSString *) name enable:(BOOL) enable
{
 
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
    for(MIKMIDIDestinationEndpoint * desty in allDestinations.allObjects)
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
    
#if LOG_MIDI_IO
    NSLog(@"NON: %@",noteOn);
#endif
    MIKMIDIDeviceManager *dm = [MIKMIDIDeviceManager sharedDeviceManager];
     for(MIKMIDIDestinationEndpoint * desty in allDestinations.allObjects)
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
     for(MIKMIDIDestinationEndpoint * desty in allDestinations.allObjects)
    {
        [dm sendCommands:@[noteOff] toEndpoint:desty error:&error];
    }
     [self remove:mNote];
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
#if LOG_MIDI_IO
                NSLog(@"NONMONO NOFF added: %d",(int)noffMe);
#endif
                MIKMIDINoteOffCommand *noteOff = [MIKMIDINoteOffCommand noteOffCommandWithNote:noffMe velocity:mVel channel:0 timestamp:date];
                [ma_data addObject:noteOff];
            }
        }
        [self removeAll];
     }
    
    // make this after the noteoff
    MIKMIDINoteOnCommand *noteOn = [MIKMIDINoteOnCommand noteOnCommandWithNote:mNote velocity:mVel channel:0 timestamp:[date dateByAddingTimeInterval:0.001]];
    [self insert:mNote];
     [ma_data addObject:noteOn];
    
#if LOG_MIDI_IO
    NSLog(@"NONMONO MA_DATA: %@",ma_data);
#endif
    MIKMIDIDeviceManager *dm = [MIKMIDIDeviceManager sharedDeviceManager];
     for(MIKMIDIDestinationEndpoint * desty in allDestinations.allObjects)
    {
        error = nil;
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
    // it might be gone already because: mono.
    if(playingNotesCount>0)
    {
        NSError *error = nil;
        NSDate *date = [NSDate date];
        NSUInteger mNote = MAX(0.0,MIN(127,floor(note+0.5)));
        NSUInteger mVel = MAX(0.0,MIN(127,vel * 127.0));
        MIKMIDINoteOffCommand *noteOff = [MIKMIDINoteOffCommand noteOffCommandWithNote:mNote velocity:mVel channel:0 timestamp:date];
        
#if LOG_MIDI_IO
        NSLog(@"NOFFMONO: %@", noteOff);
#endif
        MIKMIDIDeviceManager *dm = [MIKMIDIDeviceManager sharedDeviceManager];
        for(MIKMIDIDestinationEndpoint * desty in allDestinations.allObjects)
        {
            error = nil;
            [dm sendCommands:@[noteOff] toEndpoint:desty error:&error];
            if(error)
            {
                NSLog(@"ERROR NOFFING: %@",error);
            }
        }
        [self remove:mNote];
    }
}

- (void) ANO
{
    NSError *error = nil;
//    NSDate *date = [NSDate date];
    
    MIKMIDIControlChangeCommand *ano = [MIKMIDIControlChangeCommand controlChangeCommandWithControllerNumber: 123 value:0];

    MIKMIDIDeviceManager *dm = [MIKMIDIDeviceManager sharedDeviceManager];
     for(MIKMIDIDestinationEndpoint * desty in allDestinations.allObjects)
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
    currentlyPlayingNotes[playingNotesCount]=v;
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
