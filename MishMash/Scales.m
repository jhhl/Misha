//
//  RTScale.m
//  MishMash
//
//  Created by Henry Lowengard on 5/1/19.
//  Copyright © 2019 net.jhhl. All rights reserved.
//

#import "Scales.h"

@implementation Scales
static Scales * instance;

//put other statics here for class variables

+ (void) initialize
{
    [super initialize];
}

+ (instancetype _Nonnull) _
{
    if(!instance)
    {
        instance = [[Scales alloc] init];
    }
    return instance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        // pick up the scale from user defaults
        self.scales=[[NSMutableDictionary alloc] init];
        self.sortedKeys =[[NSMutableArray alloc]init];
        [self addBuiltInPresets];
        [self addUserDefaults];
        [self createSortedKeys];
        self.scale = self.scales[@"Default"];
        // give it something
        [self.scale digestPattern:self.scale.pattern base:60.0];
        self.cursor = self.scale.scaleNodeBaseNode;
    }
    return self;
}

- (void) addBuiltInPresets
{
    NSURL * rURL = [[NSBundle mainBundle] URLForResource:@"presetScales" withExtension:@"plist"];
    NSError * error;
//    NSString * whatthehell = [NSString stringWithContentsOfURL:rURL encoding:NSUTF8StringEncoding error:&error];
//    NSLog(@"%@",whatthehell);
    
    NSArray * presets =   [[NSArray alloc] initWithContentsOfURL:rURL error:&error];
    if(error)
    {
        NSLog(@"Error reading scale presets!");
    }
    for(NSDictionary * p in presets)
    {
        Scale * s = [[Scale alloc] init];
        s.name = p[@"name"];
        s.pattern = p[@"pattern"];
        [_scales setValue:s forKey:p[@"name"]];
    }
}
- (void) addUserDefaults
{
    NSUserDefaults * UD = [NSUserDefaults standardUserDefaults];
    NSArray * uPresets = [UD objectForKey:@"UD_PRESETS"];
    // I don't know if skins and colors can be in there.. so do it like the presets?
    for(NSDictionary * p in uPresets)
    {
        Scale * s = [[Scale alloc] init];
        s.name = p[@"name"];
        s.pattern = p[@"pattern"];
        [_scales setValue:s forKey:p[@"name"]];
    }
}
- (void) createSortedKeys
{
    // here, we just sort them boringly
    [_sortedKeys removeAllObjects];
    [_sortedKeys addObjectsFromArray:_scales.allKeys];
    [_sortedKeys sortUsingComparator:^NSComparisonResult(NSString *  _Nonnull obj1, NSString *  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
}
-(ScaleNode * _Nullable) whatIsAt:(NSInteger) step
{
    NSUInteger astep = step<0?-step:step;
    ScaleNode * dcurs = _cursor;
    for(NSUInteger i = 0; i<astep;i++)
    {
        if(dcurs)
        {
            dcurs = step>0?dcurs.up:dcurs.down;
        };
    }
    return dcurs;
}

-(ScaleNode * _Nullable) next:(NSInteger) step
{
    NSUInteger astep = step<0?-step:step;
    for(NSUInteger i = 0; i<astep;i++)
    {
        if(_cursor)
        {
            _cursor = step>0?_cursor.up:_cursor.down;
        };
    }
    return _cursor;
}
- (NSString * ) description
{
    NSMutableString * o = [[NSMutableString alloc] init];
    
    for(NSString * key in self.sortedKeys)
    {
        Scale * s = self.scales[key];
        [o appendFormat:@"-------\n%@\n",s];
    }
    return o;
}
@end
