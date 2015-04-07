// ***************************************************************************************
//  WXDSInstrumentModalBar
//  Created by Paul Webb on Sun Aug 14 2005.
// ***************************************************************************************
#import "WXDSInstrumentModalBar.h"


@implementation WXDSInstrumentModalBar

// ***************************************************************************************
-(id)   initModalBar
{
if(self=[super initInstrumentModal:4])
	{
	wave=[[WXDSWaveTable alloc]init];
	[wave loadWaveOfName: "rawwaves/marmstk1.raw"];
	[wave setFrequency:0.5];
	[self setPreset:4];
	}
return self;
}
// ***************************************************************************************
-(void) setStickHardness:(float)hardness
{
  stickHardness = hardness;
  if ( hardness < 0.0 ) {
    stickHardness = 0.0;
  }
  else if ( hardness > 1.0 ) {
    stickHardness = 1.0;
  }

[wave setFrequency:(0.25 * (float) pow(4.0, stickHardness)) ];
masterGain = 0.1 + (1.8 * stickHardness);
}
// ***************************************************************************************
-(void) setStrikePosition:(float)position
{
  strikePosition = position;
  if ( position < 0.0 ) {
    strikePosition = 0.0;
  }
  else if ( position > 1.0 ) {
    strikePosition = 1.0;
  }

  // Hack only first three modes.
  float temp2 = position * 3.14159265359;
  float temp = sin(temp2);                                       
 [self setModeGain:0 gain:0.12 * temp];

  temp = sin(0.05 + (3.9 * temp2));
   [self setModeGain:1 gain:(float) -0.03 * temp];

  temp = (float)  sin(-0.05 + (11 * temp2));
   [self setModeGain:2 gain:(float) 0.11 * temp];
}
// ***************************************************************************************
-(void) setPreset:(int)preset
{
// Presets:
//     First line:  relative modal frequencies (negative number is
//                  a fixed mode that doesn't scale with frequency
//     Second line: resonances of the modes
//     Third line:  mode volumes
//     Fourth line: stickHardness, strikePosition, and direct stick
//                  gain (mixed directly into the output
static float presets[9][4][4] = { 
{{1.0, 3.99, 10.65, -2443},		// Marimba
 {0.9996, 0.9994, 0.9994, 0.999},
 {0.04, 0.01, 0.01, 0.008},
 {0.429688, 0.445312, 0.093750}},
{{1.0, 2.01, 3.9, 14.37}, 		// Vibraphone
 {0.99995, 0.99991, 0.99992, 0.9999},	
 {0.025, 0.015, 0.015, 0.015 },
 {0.390625,0.570312,0.078125}},
{{1.0, 4.08, 6.669, -3725.0},		// Agogo 
 {0.999, 0.999, 0.999, 0.999},	
 {0.06, 0.05, 0.03, 0.02},
 {0.609375,0.359375,0.140625}},
{{1.0, 2.777, 7.378, 15.377},		// Wood1
 {0.996, 0.994, 0.994, 0.99},	
 {0.04, 0.01, 0.01, 0.008},
 {0.460938,0.375000,0.046875}},
{{1.0, 2.777, 7.378, 15.377},		// Reso
 {0.99996, 0.99994, 0.99994, 0.9999},	
 {0.02, 0.005, 0.005, 0.004},
 {0.453125,0.250000,0.101562}},
{{1.0, 1.777, 2.378, 3.377},		// Wood2
 {0.996, 0.994, 0.994, 0.99},	
 {0.04, 0.01, 0.01, 0.008},
 {0.312500,0.445312,0.109375}},
{{1.0, 1.004, 1.013, 2.377},		// Beats
 {0.9999, 0.9999, 0.9999, 0.999},	
 {0.02, 0.005, 0.005, 0.004},
 {0.398438,0.296875,0.070312}},
{{1.0, 4.0, -1320.0, -3960.0},		// 2Fix
 {0.9996, 0.999, 0.9994, 0.999},	
 {0.04, 0.01, 0.01, 0.008},
 {0.453125,0.453125,0.070312}},
{{1.0, 1.217, 1.475, 1.729},		// Clump
 {0.999, 0.999, 0.999, 0.999},	
 {0.03, 0.03, 0.03, 0.03 },
 {0.390625,0.570312,0.078125}},
};

int i,temp = (preset % 9);
for(i=0; i<nModes; i++) 
{
[self setRatioAndRadius:i  ratio:presets[temp][0][i] radius:presets[temp][1][i]];
[self setModeGain:i gain:presets[temp][2][i]];
}

[self setStickHardness:presets[temp][3][0]];
[self setStrikePosition:presets[temp][3][1]];
directGain = presets[temp][3][2];

if (temp == 1) // vibraphone
vibratoGain = 0.2;
else
vibratoGain = 0.0;

}
// ***************************************************************************************
@end
