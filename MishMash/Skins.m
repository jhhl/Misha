//
//  Skins.m
//  MishMash
//
//  Created by Henry Lowengard on 4/12/19.
//  Copyright © 2019 net.jhhl. All rights reserved.
//

#import "Skins.h"

@interface Skins()
{
    Skin * _currentSkin;
}
@end
#define N_NEW_SKIN @"NEW_SKIN"

@implementation Skins

static Skins * instance;


+ (void) initialize
{
    [super initialize];
    
}

+ (instancetype _Nonnull) _
{
    if(!instance)
    {
        instance = [[Skins alloc] init];
    }
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _skins = [[NSMutableDictionary alloc] init];
        [self addBuiltInPresets];
        [self addUserDefaults];
        [self createSortedKeys];
        
        NSUserDefaults * UD = [NSUserDefaults standardUserDefaults];
        NSString * cpName =[UD objectForKey:@"UD_CURRENT_SKIN_NAME"];
        Skin * tSkin = [self skinNamed:cpName];
        if(!(tSkin.name && tSkin.name.length>0))
        {
            tSkin = [self skinNamed:@"Default"];
        }
        self.currentSkin = tSkin;
        
    }
    return self;
}

/**
 yeah this could have been a dictionary. 

 @param name name we seek
 @return the Skin or NULL
 */
- (Skin * _Nullable) skinNamed:(NSString *) name
{
    Skin * skin = _skins[name];
    return skin;
}

//MARK: - skin reading
 

/**
 Read the plist and convert it to skins.
 */
- (void) addBuiltInPresets
{
    NSURL * rURL = [[NSBundle mainBundle] URLForResource:@"presetSkins" withExtension:@"plist"];
    NSError * error;
    NSArray * presets = [NSArray arrayWithContentsOfURL:rURL
                                                  error:&error];
    if(error)
    {
        NSLog(@"Error reading presets!");
    }
    for(NSDictionary * p in presets)
    {
        Skin * s = [[Skin alloc] init];
        s.name = p[@"name"];
        s.cl_bg_main = [UIColor colorWithHTMLName:p[@"cl_bg_main"]];
        s.cl_bg = [UIColor colorWithHTMLName:p[@"cl_bg"]];
        s.cl_hi = [UIColor colorWithHTMLName:p[@"cl_hi"]];
        s.cl_lo = [UIColor colorWithHTMLName:p[@"cl_lo"]];
        s.cl_edge1 = [UIColor colorWithHTMLName:p[@"cl_edge1"]];
        s.cl_edge2 = [UIColor colorWithHTMLName:p[@"cl_edge2"]];
        s.cl_hi_text = [UIColor colorWithHTMLName:p[@"cl_hi_text"]];
        s.cl_lo_text = [UIColor colorWithHTMLName:p[@"cl_lo_text"]];
        [_skins setValue:s forKey:p[@"name"]];
    }
}


- (void) addUserDefaults
{
    NSUserDefaults * UD = [NSUserDefaults standardUserDefaults];
    NSArray * uPresets = [UD objectForKey:@"UD_PRESETS"];
    // I don't know if skins and colors can be in there.. so do it like the presets?
    for(NSDictionary * p in uPresets)
    {
        Skin * s = [[Skin alloc] init];
        s.name = p[@"name"];
        s.cl_bg_main = [UIColor colorWithHTMLName:p[@"cl_bg_main"]];
        s.cl_bg = [UIColor colorWithHTMLName:p[@"cl_bg"]];
        s.cl_hi = [UIColor colorWithHTMLName:p[@"cl_hi"]];
        s.cl_lo = [UIColor colorWithHTMLName:p[@"cl_lo"]];
        s.cl_edge1 = [UIColor colorWithHTMLName:p[@"cl_edge1"]];
        s.cl_edge2 = [UIColor colorWithHTMLName:p[@"cl_edge2"]];
        s.cl_hi_text = [UIColor colorWithHTMLName:p[@"cl_hi_text"]];
        s.cl_lo_text = [UIColor colorWithHTMLName:p[@"cl_lo_text"]];
        [_skins setValue:s forKey:p[@"name"]];
    }
    
}
- (void) createSortedKeys
{
    // here, we just sort them boringly
    [_sortedKeys removeAllObjects];
    [_sortedKeys addObjectsFromArray:_skins.allKeys];
    [_sortedKeys sortUsingComparator:^NSComparisonResult(NSString *  _Nonnull obj1, NSString *  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
}
//MARK: - set get .. sends notification when set so skinned things can change color!
- (void) setCurrentSkin:(Skin * ) s
{
    if(!s)
    {
        s=_skins[@"Default"];
    }
    _currentSkin = s;
    // also set this name as user's latest name
    NSUserDefaults * UD = [NSUserDefaults standardUserDefaults];
    [UD setObject:s.name forKey:@"UD_CURRENT_SKIN_NAME"];

    [[NSNotificationCenter defaultCenter] postNotificationName:N_NEW_SKIN object:_currentSkin];
}
- (Skin * ) currentSkin
{
    return _currentSkin;
}

- (void) setSkinToPresetNamed:(NSString *) pname
{
    self.currentSkin = self.skins[pname];
}
/**
 the idea is : the skinnable thing uses this to change skin-ness when  a new skin is picked.
 ideall, this would be a Protocol. or something.

 @param action to perform
 @return observer id
 */
+ (id) afterChangingSkinDoThis:(void (^ _Nullable)(Skin * s))action
{
    NSNotificationCenter * N = [NSNotificationCenter defaultCenter];
    id observer = [N addObserverForName:N_NEW_SKIN object:NULL queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * n)
     {
         Skin * cSkin = [n object];
         action(cSkin);
     }];
    return observer;
}
@end
