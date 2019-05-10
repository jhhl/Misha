//
//  MIDILearnAddress.m
//  MishMash
//
//  Created by Henry Lowengard on 5/6/19.
//  Copyright © 2019 net.jhhl. All rights reserved.
//

#import "MIDIMapAddress.h"

@implementation MIDIMapAddress

- (NSString * ) midiString
{
    NSString * codeString;
    switch(self.mappedMidiCommand & 0xF0)
    {
        default:
            codeString = @"Ⓧ";
            break;
        case 0xB0:
            codeString =@"Ⓒ";
            break;
        case 0x90:
            codeString=@"Ⓝ";
            break;
    }
    
    return [NSString stringWithFormat: @"%@ %2d:%3d",
            codeString,
            (int)(self.mappedMidiCommand & 0x0F)+1,
            (int)self.mappedMidiData
            ];
}
@end
