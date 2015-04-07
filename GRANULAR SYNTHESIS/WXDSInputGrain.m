// ***************************************************************************************
//  WXDSInputGrain
//  Created by Paul Webb on Tue Jan 11 2005.
// ***************************************************************************************

#import "WXDSInputGrain.h"

// ***************************************************************************************

@implementation WXDSInputGrain

// ***************************************************************************************
-(void)		setInputBuffers:(float*)b1 right:(float*)b2 size:(int)size
{
bufferInputLeft=b1;
bufferInputRight=b2;
bufferSize=size;
halfSize=bufferSize/2;
startPos1=0;
startPos2=halfSize/2;
}
// ***************************************************************************************
-(void)		setPositions:(int)pos1 pos2:(int)pos2
{
startPos1=pos1;
startPos2=pos2;

}
// ***************************************************************************************
-(void)		setBufferPosition:(int)pos  channel:(short)channel
{
bufferPosition=pos;
if(frequency>=0.0)
	playPosition=(bufferPosition-halfSize)+WXURandomInteger(startPos1,startPos2);
else
	playPosition=bufferPosition-WXURandomInteger(startPos1,startPos2);

	
if(playPosition<0)				playPosition=(bufferSize-1)+playPosition;
if(playPosition>=bufferSize)	playPosition=playPosition-bufferSize;

if(channel==0) useBuffer=bufferInputLeft; else useBuffer=bufferInputRight;
}
// ***************************************************************************************
-(void)			initGrain:(float)freq gain:(float)g pan:(float)pan dur:(int)dur wave:(float*)wp env:(float*)ep index:(int)i
{
index=i;
frequency=freq;
gain=g;
wavePointer=wp;
envelopePointer=ep;
tickCountDown=dur;
panPosition=pan;
waveIndex=0;
envelopeIndex=0;
envelopeIncrement=44100.0/(float)dur;
waveIncrement=frequency*1.0;
}
// ***************************************************************************************
-(void)			tick
{
if(tickCountDown>0) tickCountDown--; 
else 
	{
	leftSample=rightSample=0.0;
	return;
	}

sample=useBuffer[(int)playPosition];
playPosition+=waveIncrement;
if(playPosition>=bufferSize) playPosition=playPosition-bufferSize; else 
if(playPosition<0) playPosition=bufferSize+playPosition;

sample=sample*envelopePointer[(int)envelopeIndex];
envelopeIndex+=envelopeIncrement;
sample*=gain;
rightSample=sample*panPosition;
leftSample=sample*(1.0-panPosition);
}
// ***************************************************************************************

@end
