// ************************************************************************************************
//  WXDSRenderBase
//  Created by Paul Webb on Wed Dec 29 2004.
// ************************************************************************************************
// New Render Base Class for coreaudio cocoa
//
// CONTROL GENERAL FOR ALL
//
//  setMasterGain
//  setMasterPan
//  setRenderActive
// ************************************************************************************************
#import <Foundation/Foundation.h>
#import "AudioToolBox/AUGraph.h"


//#import "WXUsefullCode.h"
// ************************************************************************************************

@interface WXDSRenderBase : NSObject {

AURenderCallbackStruct  myCallback;
NSString*   renderName;

double degree1,delta1;

UInt32  currentFrame;
int		preBlankSize;
float   masterGain,masterPan,leftSample,rightSample,theSample,panRight,panLeft;
BOOL	isActive;

id   updateCollection;
id   panControl;
}

-(id)							initWithFreq:(double)r;
-(void)							setRenderName:(NSString*)name;
-(AURenderCallbackStruct*)		getCallBackPointer;
-(void)							doReset;
-(void)							doPreStart;
-(void)							setMasterGain:(float)gain;
-(void)							setFrequency:(float)freq;
-(void)							shiftPan:(float)ammount;
-(void)							setMasterPan:(float)pan;
-(void)							setRenderActive:(BOOL)state;
-(void)							setPreBlankSize:(int)size;
-(void)							doTimedAction;
-(void)							setUpdateCollection:(id)uC;
-(void)							setPanControl:(id)pC;
//		control using ids
-(void)				doController:(int)index value:(float)value;
-(void)				doControllerExtra:(int)index value:(float)value;
-(void)				setFrequencyNSO:(id)freq;
-(void)				setMasterGainNSO:(id)gain;
-(void)				setMasterPanNSO:(id)pan;	
-(void)				shiftPanNSO:(id)ammount;
-(void)				setRenderActiveNSO:(id)state;

//  PRIVATE.......
-(OSStatus)			audioCallbackOnDevice:(AudioBufferList*)ioData bus:(UInt32)bus frame:(UInt32)inNumFrames  time:(AudioTimeStamp*)timeStamp;
-(OSStatus)			RenderBlank:(AudioBufferList*)ioData bus:(UInt32)bus frame:(UInt32)inNumFrames;
-(void)				doMonoToStereoPan:(AudioBufferList*)ioData frame:(UInt32)inNumFrames;


@end
