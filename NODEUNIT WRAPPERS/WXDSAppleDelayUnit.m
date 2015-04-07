// ******************************************************************************************
//  WXDSAppleDelayUnit
//  Created by Paul Webb on Mon Jan 10 2005.
// ******************************************************************************************
#import "WXDSAppleDelayUnit.h"
// ******************************************************************************************
@implementation WXDSAppleDelayUnit

// ******************************************************************************************
-(id)		init
{
if(self=[super init])
	{
	
	}
return self;
}
// ******************************************************************************************
-(void)		addToGraph:(WXAUGraph*)dest name:(NSString*)name
{
[dest addNodeFilter:@"TEST" subtype:kAudioUnitSubType_Delay];
theUnit=[dest unitByName:name];
}
// ******************************************************************************************
-(void)		setWetDryMix:(Float32)value
{
OSStatus err=[theUnit AudioUnitSetParameter:kDelayParam_WetDryMix scope:kAudioUnitScope_Input 
		element:0 value:value inFrames:0];
if(err!=noErr) fprintf(stderr, "DELAYUNIT ERROR %ld",err); 		
}
// ******************************************************************************************
-(void)		DelayTime:(Float32)value
{
OSStatus err=[theUnit AudioUnitSetParameter:kDelayParam_DelayTime scope:kAudioUnitScope_Input 
		element:0 value:value inFrames:0];
		
if(err!=noErr) fprintf(stderr, "DELAYUNIT ERROR %ld",err); 	else printf("okay delay\n");
}
// ******************************************************************************************
-(void)		Feedback:(Float32)value
{
OSStatus err=[theUnit AudioUnitSetParameter:kDelayParam_Feedback scope:kAudioUnitScope_Input 
		element:0 value:value inFrames:0];
if(err!=noErr) fprintf(stderr, "DELAYUNIT ERROR %ld",err); 		
}
// ******************************************************************************************
-(void)		LopassCutoff:(Float32)value
{
OSStatus err=[theUnit AudioUnitSetParameter:kDelayParam_LopassCutoff scope:kAudioUnitScope_Input 
		element:0 value:value inFrames:0];
if(err!=noErr) fprintf(stderr, "DELAYUNIT ERROR %ld",err); 
}
// ******************************************************************************************


@end
