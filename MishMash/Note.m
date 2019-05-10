//
//  Note.m
//  MishMash
//
//  Created by Henry Lowengard on 4/10/19.
//  Copyright © 2019 net.jhhl. All rights reserved.
//

#import "Note.h"
@implementation Note
- (NSString * ) name
{
    return MIKMIDINoteLetterAndOctaveForMIDINote((UInt8) self.dmidi);
}
- (NSString * ) description
{
    return [NSString stringWithFormat:@"(%@ %.2f)",[self name],self.dmidi];
}
@end
