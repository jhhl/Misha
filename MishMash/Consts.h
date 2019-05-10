//
//  Consts.h
//  MishMash
//
//  Created by Henry Lowengard on 4/10/19.
//  Copyright © 2019 net.jhhl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define SAMPLE_RATE 44100.0


#define CENTBASE 1.0005777895065548
#define ET12 1.0594630943592953
#define MIDI_00 16.351597831287418
#define MIDI_12 (MIDI_00*2.0)
#define MIDI_24 (MIDI_00*4.0)
#define MIDI_36 (MIDI_00*8.0)
#define MIDI_48 (MIDI_00*16.0)
#define MIDI_60 (MIDI_00*32.0)


#define TET12 1.0594630943592953
#define ONE_CENT 1.0005777895065548
#define PI 3.141592653589793
#define TWO_PI 6.283185307179586
#define HALF_PI 1.5707963267948966
#define LOG2 0.6931471805599453

#define MIDI_TO_12TET_FREQ(x) (MIDI_00*powf(TET12,x))
#define HZ_TO_MIDI(x) (log(x/MIDI_00)/log(TET12))

#define INTERVAL_TO_CENTS(x) (log(x)/log(ONE_CENT))
#define CENTS_TO_INTERVAL(x) pow(ONE_CENT,x)

#define HALF_LIFE_IN_SECS(x) (powf(0.5,1.0/x))
#define HALF_LIFE_SECS_IN_FRAMES(x) (powf(0.5,1.0/(x*SAMPLE_RATE)))

#define CLIP01(a) MIN(1.0,MAX(0.0,(a)))
#define CLIPM1P1(a) MIN(1.0,MAX(-1.0,(a)))

#define R(a) fmodf((a),1.0)

typedef double dmidi;



@interface Consts : NSObject

@end

NS_ASSUME_NONNULL_END
