// ***************************************************************************************
//  WXDSBasicWhiteNoiseWave
//  Created by Paul Webb on Wed Apr 13 2005.
// ***************************************************************************************
#import <Foundation/Foundation.h>
#import "WXDSBasicForFilterSeriesAndWaveTable.h"
#import "WXUsefullCode.h"
#import "WXFilterPRCReverb.h"
#import "WXCombFilterFeedBack.h"
// ***************************************************************************************

@interface WXDSBasicWhiteNoiseWave : WXDSBasicForFilterSeriesAndWaveTable {


int		counter,resolution,changeChance;
float   currentSample;

WXFilterPRCReverb		*reverb;
WXCombFilterFeedBack	*combFilter;
}

-(void)		setResolution:(int)r;
-(void)		setResolutionNSO:(id)r;


-(void)		setCombFB:(float)v;
-(void)		setCombDelay:(float)v;
-(void)		setChangeChance:(int)v;

// ***************************************************************************************

@end
