// ***************************************************************************************
//  WXDSBasicMixer
//  Created by Paul Webb on Sun Mar 27 2005.
// ***************************************************************************************
//
// this is my basic mixer that can have any number of inputs ( WXDSRenderBase )
// and these can be dynamically changed at any time. 
//
//
// HERE IS AN EXAMPLE OF USING IT::::
//
// myAUGraph=[[WXAUGraph alloc]init];
// [myAUGraph setUpUsingStereoMixer:2];
//
// myBasicMixer=[[WXDSBasicMixer alloc]init];
// [myBasicMixer addToMix:[[WXDSBasicSineWave alloc]initWithFreq:440]];
// [myBasicMixer addToMix:[[WXDSBasicSineWave alloc]initWithFreq:660]];
// [myBasicMixer addToMix:[[WXDSBasicSineWave alloc]initWithFreq:160]];
// [myBasicMixer addToMix:[[WXDSBasicSineWave alloc]initWithFreq:260]];
//
// [myAUGraph addRenderer:myBasicMixer to:@"MAINMIXER" forBus:0 andName:@"render1"];
//
//
// what is does is call each renderer in turn and generate its data, sums this into the
// total1, total2 (left/right) then writes this out to the out1,out2 with divisions 
//
// this can be be made more into a mixer fairly easy by left/right pans and mix weights for
// each render input channel.
//
// its quite usefull as can add destroy number things being mixed when AUGraph is running
//
// ***************************************************************************************

#import <Foundation/Foundation.h>
#import "WXDSRenderBase.h"

// ***************************************************************************************


@interface WXDSBasicMixer : WXDSRenderBase {

BOOL	inputActive[32];
float   total1[1024];
float   total2[1024];
NSMutableArray  *mixRenderers;
}

-(void) setInputActive:(int)index state:(BOOL)state;
-(id)   objectAtIndex:(int)index;
-(int)  count;
-(void) removeRenderer:(WXDSRenderBase*)renderer;
-(void) addToMix:(WXDSRenderBase*)renderer;
-(void) replaceRenderAtIndex:(int)index withRender:(WXDSRenderBase*)renderer;
-(void) printInfo;


@end
