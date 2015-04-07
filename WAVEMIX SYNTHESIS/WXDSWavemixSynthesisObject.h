// ******************************************************************************************
//  WXDSWavemixSynthesisObject
//  Created by Paul Webb on Thu Jul 21 2005.
// ******************************************************************************************

#import <Foundation/Foundation.h>
#import "AudioToolBox/AUGraph.h"
#import "WXUsefullCode.h"
#import "WXDSRenderBase.h"
#import "WXDSEnvelopeBasic.h"

// ******************************************************************************************

@interface WXDSWavemixSynthesisObject : NSObject {

int			waveSize,startTime,endTime,duration,currentDuration,renderCount;
int			preBlankSize,renderSize,postBlankSize;

float		masterGain,panLeft,panRight;
BOOL		done;

WXDSRenderBase  *renderer;

WXDSEnvelopeBasic   *theEnvelope;
WXDSEnvelopeBasic   *thePanEnvelope;
}


-(id)		initFromTime:(int)ctime;
-(BOOL)		done;
-(int)		duration;
-(void)		setStartEndTime:(int)start end:(int)end;
-(void)		setStartAndDuration:(int)start dur:(int)dur;
-(void)		setRenderer:(WXDSRenderBase*)r;
-(void)		setMasterGain:(float)gain;
-(void)		setEnvelope:(float*)env;
-(void)		setSoundEnvelope:(WXDSEnvelopeBasic*)env;
-(void)		setPanEnvelope:(WXDSEnvelopeBasic*)env;
-(void)		doRenderWave:(int)ctime ioData:(AudioBufferList*)ioData bus:(UInt32)bus frame:(UInt32)inNumFrames time:(AudioTimeStamp*)timeStamp;
@end
