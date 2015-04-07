// ***************************************************************************************
//  WXDSExpWhiteNoiseRythmicsOne
//  Created by Paul Webb on Sun Sep 18 2005.
// ***************************************************************************************
//
//
//
//
//
// ***************************************************************************************

#import <Foundation/Foundation.h>
#import "WXDSRenderBase.h"
#import "WXDSFilterSeries.h"
#import "WXSPKitBWBandPassFilter.h"
#import "WXFilterJohnChowningReverb.h"
#import "WXCombFilterFeedBack.h"
#import "WXDSEnvelopeTableMaker.h"
// ***************************************************************************************

@interface WXDSExpWhiteNoiseRythmicsOne : WXDSRenderBase {

int			patternCounter,patternRateCounter,patternLength,currentPattern,patternRate;
int			counter,resolution,hihatCounter;
float		currentSample;
float		patternGain;
float		sample2;
NSMutableString	*pattern[10];

WXDSFilterSeries			*filterSeries;
WXSPKitBWBandPassFilter		*bandPass;
WXFilterJohnChowningReverb  *reverb;
WXCombFilterFeedBack		*comb;

//
int		resetCount,resetEvery;
BOOL	doPanShift;

float   level,origPan,panShift;
double  degree2;
double  delta2,delta3,delta4,delta5;
double  deltaStart1,deltaStart2,deltaStart4;

WXDSEnvelopeTableMaker  *envelopeMaker;
float   *envelopeShape;
}

-(void)		setResolution:(int)r;
-(void)		setWhiteFilter:(float)centre bw:(float)bw gain:(float)gain pan:(float)pan; 
-(void)		doPattern;

@end
