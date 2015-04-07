// ************************************************************************************************
//  WXDSRenderBase
//  Created by Paul Webb on Wed Dec 29 2004.
// ************************************************************************************************
//
//  masterGain is from 0.0 to 1.0 (but can make it higher)
//  masterPan is from  0.0 to 1.0
//
// ************************************************************************************************

#import "WXDSRenderBase.h"


@implementation WXDSRenderBase

// ************************************************************************************************
-(id)		init
{
if(self=[super init])
	{
	currentFrame=0;
	isActive=YES;
	masterGain=0.2;
	degree1=0;
	delta1=WXUFreqToDelta(220);
	masterPan=0.5;
	[self setMasterPan:0.5];
	preBlankSize=0;
	updateCollection=0;
	}
return self;
}
// ************************************************************************************************
-(id)		initWithFreq:(double)r
{
if(self=[super init])
	{
	isActive=YES;
	masterGain=0.2;
	[self setMasterPan:0.5];
	delta1=WXUFreqToDelta(r);
	degree1=0.0;
	preBlankSize=0;
	updateCollection=nil;
	panControl=nil;
	}
return self;
}
// ************************************************************************************************
-(void)			setUpdateCollection:(id)uC
{
updateCollection=uC;
}
// ************************************************************************************************
-(void)			setPanControl:(id)pC
{
panControl=pC;
}
// ************************************************************************************************
-(void)			doTimedAction
{
}
// ************************************************************************************************
-(AURenderCallbackStruct*)		getCallBackPointer
{
return &myCallback;
}
// ************************************************************************************************
-(void)		setRenderName:(NSString*)name
{
renderName=name;
[renderName retain];
}
// ************************************************************************************************
-(void)		setPreBlankSize:(int)size
{
preBlankSize=size;
}
// ************************************************************************************************
-(void)		doController:(int)index value:(float)value
{
switch(index)
	{
	case 1:		[self setRenderActive:(BOOL)value];		break;
	case 2:		[self setMasterGain:value];				break;
	case 3:		[self setFrequency:value];				break;
	case 4:		[self setMasterPan:value];				break;
	case 5:		[self shiftPan:value];					break;
	
	default:	[self doControllerExtra:index value:value];		break;
	}
}
// ************************************************************************************************
-(void)		doControllerExtra:(int)index value:(float)value
{

}
// ************************************************************************************************
-(void)		setFrequencyNSO:(id)freq		{		[self setFrequency:[freq floatValue]];				}
-(void)		setMasterGainNSO:(id)gain		{		masterGain=[gain floatValue];						}
-(void)		setMasterPanNSO:(id)pan			{		[self setMasterPan:[pan floatValue]];			}
-(void)		shiftPanNSO:(id)ammount			{		[self shiftPan:[ammount floatValue]];			}
-(void)		setRenderActiveNSO:(id)state	{		[self setRenderActive:[state floatValue]];		}
// ************************************************************************************************
-(void)		setFrequency:(float)freq
{
delta1=WXUFreqToDelta(freq);
}
// ************************************************************************************************
-(void)		setMasterGain:(float)gain
{
masterGain=gain;
}
// ************************************************************************************************
-(void)		shiftPan:(float)ammount
{
masterPan+=ammount;
if(masterPan<-1.0) masterPan=-1.0; else if(masterPan>1.0) masterPan=1.0;
panRight=masterPan;
panLeft=(1.0-masterPan);
}
// ************************************************************************************************
-(void)		setMasterPan:(float)pan
{
masterPan=pan;
panRight=masterPan;
panLeft=(1.0-masterPan);
}
// ************************************************************************************************
-(void)		setRenderActive:(BOOL)state
{
isActive=state;			
}
// ************************************************************************************************
-(void)			doReset
{
}
// ************************************************************************************************
-(void)			doPreStart
{
}
// ************************************************************************************************
// This is based on sample data being first placed in [0] i.e out1
// then it adjusts them both to put in the pan position
//
// CAN OVERRIDE THIS IF WISH
// ************************************************************************************************
-(void)				doMonoToStereoPan:(AudioBufferList*)ioData frame:(UInt32)inNumFrames
{
UInt32 i;
float* out1 =(float*) ioData->mBuffers[0].mData;
float* out2 =(float*) ioData->mBuffers[1].mData;

float inputSample;

for (i=0; i<inNumFrames; ++i) 
	{
	inputSample=*out1;
	
	if(panControl!=nil) [panControl doUpdate];
	//masterPan=
	
	
	*out1++=inputSample*panRight;
	*out2++=inputSample*panLeft;

	}
}
// ************************************************************************************************
-(OSStatus)		audioCallbackOnDevice:(AudioBufferList*)ioData bus:(UInt32)bus frame:(UInt32)inNumFrames time:(AudioTimeStamp*)timeStamp
{

if(!isActive) return [self RenderBlank:ioData bus:bus frame:inNumFrames];
UInt32 i;

float* out1 =(float*) ioData->mBuffers[0].mData;
float* out2 =(float*) ioData->mBuffers[1].mData;

out1=out1+preBlankSize*2;
out2=out2+preBlankSize*2;

for (i=0; i<inNumFrames; ++i) 
	{
	if(updateCollection!=nil)   [updateCollection doUpdate];
	leftSample=sin(degree1);
	*out1++ = leftSample*masterGain*panRight;
	*out2++ = leftSample*masterGain*panLeft;

	degree1+=delta1;
	}
	
return noErr;
}
// ******************************************************************************************
-(OSStatus)	    RenderBlank:(AudioBufferList*)ioData bus:(UInt32)bus frame:(UInt32)inNumFrames
{
memset(ioData->mBuffers[0].mData,0,inNumFrames*4);		// fill block with zero chars
memset(ioData->mBuffers[1].mData,0,inNumFrames*4);		// *4 as sizeof(float)==4
return noErr;
}
// ************************************************************************************************
@end
