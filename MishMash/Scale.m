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
    dpattern_count = 0;
    repeat = 0.0; // this is the repeat as inntervals (midi 12ED2)
    
    for( NSString * part in parts)
    {
        dmidi this = [part doubleValue]; // this might get sophisticated
        dpattern[dpattern_count++] = this;
        repeat+=this;
    }
    // now dial down the midi from the base until it's >= 0
    dmidi zero = base;
    NSUInteger place = dpattern_count-1;
    while(zero>0.0)
    {
        zero-=dpattern[place];
        place = (dpattern_count + place-1) % dpattern_count;
    }
    // back up ..
    place = (place+1 ) % dpattern_count;
    if(zero<0.0)
    {
        // back up more
        place = (place+1 ) % dpattern_count;
        zero +=dpattern[place];
    }
    
    // now fill up the actual array
    // this could actually be a C array, with some maint.
    // however, we'd have to know how big to make it, in case of 96EDO or whatever
    // this sets up a boring linear up-down set of links.
    //
    [self clearScaleNode:_scaleNodeCursor];
    
    _scaleNodeBaseNode=NULL;
    _scaleNodeFirst=NULL;
    _scaleNodeCursor=NULL;
    
    for(dmidi mi=zero;mi<128;)
    {
        ScaleNode * node = [[ScaleNode alloc] init];
        node.note = [[Note alloc] init];

        node.note.dmidi = mi;
        // figure a name for this?
        
        node.down = _scaleNodeCursor;
        _scaleNodeCursor.up = node;
        _scaleNodeCursor = node;
        
        // ideally, if you go down, you go back up and hit the base note.
        if(node.note.dmidi == base)
        {
            _scaleNodeBaseNode = node;
        }
        if(_scaleNodeBaseNode == NULL)
        {
            _scaleNodeBaseNode = node; // just so it's set to something.
        }
        if(_scaleNodeFirst == NULL)
        {
            _scaleNodeFirst = node; // so we can scan the whole thing
        }
        
        mi+=dpattern[place];
        
        place= (place+1) %dpattern_count;
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
