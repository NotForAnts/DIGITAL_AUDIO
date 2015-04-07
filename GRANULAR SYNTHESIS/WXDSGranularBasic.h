// ***************************************************************************************
//  WXDSGranularBasic
//  Created by Paul Webb on Thu Dec 30 2004.
// ***************************************************************************************
//
// I think it is best to subclass them rather than to use a delegate which does the
// grain spawning
//
// ***************************************************************************************
#import <Foundation/Foundation.h>
#import "WXDSRenderBase.h"
#import "WXDSGrain.h"
#import "WXDSGrainSlide.h"
#import "WXDSFilterSeries.h"
#import "WXDSEnvelopeTableMaker.h"
// ******************************************************************************************
#define WXDSGranularBasicMaxGrains  1000
#define WXDSGranularBasicMaxTables  10
// ***************************************************************************************
@interface WXDSGranularBasic : WXDSRenderBase {

int					counter,grainPerSecondEveryCount,nextGrainAtCounter,grainAddIndex;
int					GPS1,GPS2,wave1,wave2,envelope1,envelope2,duration1,duration2;
float				grainFreq1,grainFreq2,gain1,gain2,pan1,pan2;
float				leftGrainSample,rightGrainSample;
	
float				*grainWaves[WXDSGranularBasicMaxTables];
float				*grainEnvelope[WXDSGranularBasicMaxTables];	
int					freeIndexStore[WXDSGranularBasicMaxGrains],freePlace;
Boolean				useFilter;
WXDSGrain			*grains[WXDSGranularBasicMaxGrains];
WXDSGrain			*activeGrainFirst,*activeGrainLast,*cGrain;

WXDSEnvelopeTableMaker  *waveTableMaker;
//  filter series for left and right channels
WXDSFilterSeries	*leftFilterSeries;
WXDSFilterSeries	*rightFilterSeries;
}

-(void)	setWaveTable:(int)index table:(float*)table;
-(void)	setEnvelopeTable:(int)index table:(float*)table;
-(void) initialiseParameters;
-(void) initialiseGrains;
-(void) addGrain:(WXDSGrain*)theGrain;
-(int)  getMaxGrains;
-(void) initialiseWaveTables;

//		BASIC CONTROL PARAMETERS
-(void)	setGrainsPerSecond:(int)gps;
-(void)	setGrainsPerSecondRange:(int)r1 r2:(int)r2;
-(void)	setGrainRatePeriodAsSamples:(int)r1 r2:(int)r2;
-(void)	setGrainRatePeriodAsMilliSeconds:(int)r1 r2:(int)r2;

-(void)	setGrainFrequencyRange:(float)f1 f2:(float)f2;
-(void)	setGrainDurationAsSamples:(int)r1 r2:(int)r2;
-(void)	setGrainDurationAsMilliSeconds:(int)r1 r2:(int)r2;
-(void)	setGrainGainRange:(float)r1 r2:(float)r2;
-(void)	setGrainPanRange:(float)r1 r2:(float)r2;
-(void)	setGrainWaveRange:(int)r1 r2:(int)r2;
-(void)	setGrainEnvelopeRange:(int)r1 r2:(int)r2;

// INDIVIDUAL PARAMETER CONTROL
-(void)	setGrainsPerSecondRange1:(int)r1;
-(void)	setGrainsPerSecondRange2:(int)r1;
-(void)	setGrainFrequencyRange1:(float)f1;
-(void)	setGrainFrequencyRange2:(float)f1;
-(void) setGrainFrequencyGain1:(float)v;
-(void) setGrainFrequencyGain2:(float)v;
-(void) setGrainDurAsSamples1:(float)v;
-(void) setGrainDurAsSamples2:(float)v;	

//		NSO CONTROL PARAMETERS
-(void)	setGrainsPerSecondNSO:(id)ob;
-(void)	setGrainsPerSecondRange1NSO:(id)ob;
-(void)	setGrainsPerSecondRange2NSO:(id)ob;
-(void)	setGrainRatePeriodAsSamplesRange1NSO:(id)ob;
-(void)	setGrainRatePeriodAsSamplesRange2NSO:(id)ob;
-(void)	setGrainRatePeriodAsMilliSecondsRange1NSO:(id)ob;
-(void)	setGrainRatePeriodAsMilliSecondsRange1NSO:(id)ob;

-(void)	setGrainFrequencyRange1NSO:(id)ob;
-(void)	setGrainFrequencyRange2NSO:(id)ob;
-(void)	setGrainDurationAsSamplesRange1NSO:(id)ob;
-(void)	setGrainDurationAsSamplesRange2NSO:(id)ob;
-(void)	setGrainDurationAsMilliSecondsRange1NSO:(id)ob;
-(void)	setGrainDurationAsMilliSecondsRange2NSO:(id)ob;
-(void)	setGrainGainRange1NSO:(id)ob;
-(void)	setGrainGainRange2NSO:(id)ob;
-(void)	setGrainPanRange1NSO:(id)ob;
-(void)	setGrainPanRange2NSO:(id)ob;
-(void)	setGrainWaveRange1NSO:(id)ob;
-(void)	setGrainWaveRange2NSO:(id)ob;
-(void)	setGrainEnvelopeRange1NSO:(id)ob;
-(void)	setGrainEnvelopeRange2NSO:(id)ob;

//		FOR FILTER SERIES
-(void)		setRightFilterSeries:(WXDSFilterSeries*)fP;
-(void)		setLeftFilterSeries:(WXDSFilterSeries*)fP;
-(void)		setUseFilters:(BOOL)state;

//		PRIVATE
-(int)		getFreeIndexAndUpdateGrainList;
-(float)	DurMS:(float)d;
-(void)		addGrainProcess;  // OVERRIDE


@end
