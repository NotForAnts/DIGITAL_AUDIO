// ***************************************************************************************
//  WXDSEnvelopeTableInterpolated
//  Created by Paul Webb on Thu Jan 13 2005.
// ***************************************************************************************
//
//
//
// ***************************************************************************************

#import <Foundation/Foundation.h>


@interface WXDSEnvelopeTableInterpolated : NSObject {

}


-(void)		keyOnWithGainAndDuration:(float)g dur:(float)duration;
-(void)		keyOnWithGain:(float)g;
-(void)		keyOnWithReGain:(float)g;
-(void)		keyOff;
-(BOOL)		hasFinished;
-(float)	tick;

@end
