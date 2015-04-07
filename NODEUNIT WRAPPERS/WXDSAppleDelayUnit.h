// ******************************************************************************************
//  WXDSAppleDelayUnit
//  Created by Paul Webb on Mon Jan 10 2005.
// ******************************************************************************************
// kDelayParam_WetDryMix   = 0
// kDelayParam_DelayTime   = 1
// kDelayParam_Feedback    = 2
// kDelayParam_LopassCutoff= 3  
// ******************************************************************************************
#import <Foundation/Foundation.h>
#import "AudioToolBox/AUGraph.h"
#import "WXAudioUnit.h"
#import "WXAUNode.h"
#import "WXAUGraph.h"
// ******************************************************************************************
@interface WXDSAppleDelayUnit : NSObject {

WXAudioUnit*  theUnit;
}

-(void)		addToGraph:(WXAUGraph*)dest name:(NSString*)name;
-(void)		setWetDryMix:(Float32)value;
-(void)		DelayTime:(Float32)value;
-(void)		Feedback:(Float32)value;
-(void)		LopassCutoff:(Float32)value;

@end
