//
//  Scale.m
//  MishMash
//
//  Created by Henry Lowengard on 4/10/19.
//  Copyright © 2019 net.jhhl. All rights reserved.
//

#import "Scale.h"

@implementation ScaleNode
- (NSString * ) description
{
    return [NSString stringWithFormat:@"%@%@%@",
            self.down?@"<-":@"  ",
            self.note,
            self.up?@"->":@"  "];
}
@end

@implementation Scale
+ (void)initialize
{
    if (self == [Scale class]) {
        
    }
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _scaleNodeCursor = NULL;
    }
    return self;
}

/**
 use scales as implemented by AUMI , kind of.
 a scale pattern is a list of intervals ... but expressed in dmidi not cents
 - repeat is the sum of the intervals
 - ideally, we'd be able to say 2,4,5& 6, 8 11, 12 where 5 is ascending and 6 is descending. or give a real graph.
  2 2 1 2 2 2 1
 it sets an array of playable midi (dmidi) notes, the "scale center index" is set to the index of the scale list that is the base.
 
 @param pattern list of intervals ( could include just ... we'll see!)
 @param base key, also in dmidi
 */
- (void) digestPattern: (NSString * _Nonnull) pattern base:(dmidi) base
{
    // because this is MIDI,
    dmidi dpattern[128]; // pattern is not going to be that long!
    dmidi repeat;
    NSUInteger dpattern_count;
    _pattern = [pattern copy];
    _base = base;
    NSArray * parts = [pattern componentsSeparatedByString:@","];
    
    // convert to dPattern, and find repeat
    dpattern_count = 0;
    repeat = 0.0; // this is the repeat as inntervals (midi 12ED2)
    for( NSString * part in parts)
    {
        dmidi this = [part doubleValue]; // this might get sophisticated
        dpattern[dpattern_count++] = this;
        repeat+=this;
    }
    
    // now dial down the midi from the base until it's >= 0
    // the idea is to precalculate the MIDI notes .. even if they aren't midi notes.
    // we should really stop when the midi note is <0 and >127
    // we COULD assume the base is where it should be in 12ED0, though, and then run down and up from there.
    
    
    // now fill up the actual array
    // this could actually be a C array, with some maint.
    // however, we'd have to know how big to make it, in case of 96EDO or whatever
    // this sets up a boring linear up-down set of links.
    //
    [self clearScaleNode:_scaleNodeCursor];
    // make the base node...
    ScaleNode * node = [[ScaleNode alloc] init];
    node.note = [[Note alloc] init];
    node.note.dmidi = base;
    
    _scaleNodeBaseNode=node;
    _scaleNodeFirst=NULL; // this will be the lowest node when we have one
    _scaleNodeCursor=node;
    dmidi cursor = base;
    NSUInteger place=  dpattern_count-1;
    
    // build down
    while(cursor>=0.0)
    {
        // go down by one
       cursor-=dpattern[place];
        
        if(cursor<0.0)
        {
            _scaleNodeFirst = _scaleNodeCursor;
            break;
        }
        // yeah, go down one
        place= (place-1 + dpattern_count) %dpattern_count;
        
        ScaleNode * node = [[ScaleNode alloc] init];
        node.note = [[Note alloc] init];
        node.note.dmidi = cursor;
        // figure a name for this?
        
        node.up = _scaleNodeCursor; // the last one...
        _scaleNodeCursor.down = node;
        _scaleNodeCursor = node;

    }
    // build up
    cursor = base;
    place= 1;
    _scaleNodeCursor=_scaleNodeBaseNode;
    while(cursor<=127.0)
    {
        // go up by one
        cursor+=dpattern[place];
        
        if(cursor>127.0)
        {
            break;
        }
        //go up
        place= (place+1) %dpattern_count;
        
        ScaleNode * node = [[ScaleNode alloc] init];
        node.note = [[Note alloc] init];
        node.note.dmidi = cursor;
        // figure a name for this?
        
        node.down = _scaleNodeCursor; // the last one...
        _scaleNodeCursor.up = node;
        _scaleNodeCursor = node;
    }
    
    // link the top to the bottom for now .. or .. to iteslf?
    _scaleNodeCursor.up = _scaleNodeCursor;
    // link the first guy's down to itslef too
    _scaleNodeFirst.down = _scaleNodeFirst;
}

/**
 I'd like this to be  struct, but modern Objc doesn't like NSStrings  in a struct.
this is a little tricky because down and up may point to myself.
 @param here node to free
 */
-  (void) clearScaleNode:(ScaleNode *) here
{
     here = NULL;
    return;
    
//    if(here!=NULL)
//    {
//        ScaleNode * t= here.down;
//        here.down = NULL;
//
//        [self clearScaleNode:t];
//        t= here.up;
//         here.up = NULL;
//        [self clearScaleNode:t];
//
//        // free the actual node info.
//        here.note = NULL;
//        here = NULL;
//     }
}

//MARK: - next, any number of steps and direction

- (NSString * ) description
{
    NSMutableString * s = [[NSMutableString alloc]init];
    NSUInteger count = 0 ;
    ScaleNode * cNode = _scaleNodeFirst;
    [s appendFormat:@"%@ Base: %f Pattern: %@\n",  _name,_base,_pattern];

    while(cNode)
    {
        [s appendFormat:@"  %d: %@%@\n",
         (int)count,
         cNode,
         cNode==_scaleNodeBaseNode?@"*":@""];
        
        count++;
        cNode = cNode.up;
    }
    
    [s appendFormat:@"Len: %lu\n",  count];
  
    return s;
}
@end
