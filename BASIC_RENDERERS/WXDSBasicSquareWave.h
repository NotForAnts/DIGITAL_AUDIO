// ***************************************************************************************
//  WXDSBasicSquareWave.h
//  Created by Paul Webb on Wed Apr 13 2005.
// ***************************************************************************************

#import <Foundation/Foundation.h>
#import "WXDSBasicForFilterSeriesAndWaveTable.h"
// ***************************************************************************************

@interface WXDSBasicSquareWave : WXDSBasicForFilterSeriesAndWaveTable {

double waveHigh;
}


-(void)			setWavehigh:(double)high;	
-(void)			setWavehighNSO:(id)high;	

// ***************************************************************************************

@end
