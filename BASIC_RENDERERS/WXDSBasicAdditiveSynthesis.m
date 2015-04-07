// ************************************************************************************************
//  WXDSBasicAdditiveSynthesis
//  Created by Paul Webb on Tue Aug 02 2005.
// ************************************************************************************************

#import "WXDSBasicAdditiveSynthesis.h"


@implementation WXDSBasicAdditiveSynthesis

// ************************************************************************************************
-(id)		initUsingWave:(int)type
{
if(self=[super init])
	{
	waveTableSize=88200;		// double size for higher freq
	waveTableSizeAsInteger=(int)waveTableSize;
	
	waveTableMaker=[[WXDSEnvelopeTableMaker alloc]init];
	
	switch(type)
		{   
		case 1:		waveTable=[waveTableMaker makeSineWaveTable:waveTableSize r1:-1.0 r2:1.0 freq:1.0];					break;  // sin
		case 2:		waveTable=[waveTableMaker makePulseTable:waveTableSize r1:-1.0 r2:1.0 freq:1.0 pulsePercent:5];		break;  // pulse
		case 3:		waveTable=[waveTableMaker makePulseTable:waveTableSize r1:-1.0 r2:1.0 freq:1.0 pulsePercent:50];	break;  // squqre
		case 4:		waveTable=[waveTableMaker makeTriangleEnvelope:waveTableSize r1:-1.0 r2:1.0];						break;  // tri
		case 5:		waveTable=[waveTableMaker makeStraightEnvelope:waveTableSize r1:-1.0 r2:1.0];						break;  // ramp
		}
	
	numberPartials=0;
	
	[self addPartial:220 gain:1.0];
	[self addPartial:221 gain:1.0];
	[self addPartial:222 gain:1.0];
	[self addPartial:223 gain:1.0];
	[self addPartial:224 gain:1.0];
	
	
	[self setFreqChange:0 freq:800 steps:44100*10];
	[self setFreqChange:1 freq:610 steps:44100*15];
	[self setFreqChange:2 freq:720 steps:44100*20];
	[self setFreqChange:3 freq:430 steps:44100*25];
	[self setFreqChange:4 freq:140 steps:44100*30];
	
	[self setGainChange:0 gain:0.5 steps:44100*10];
	//[self setGainChange:1 gain:0 steps:44100*10];
	[self setGainChange:2 gain:0.5 steps:44100*10];
	//[self setGainChange:3 gain:0 steps:44100*10];
	[self setGainChange:4 gain:1.3 steps:44100*10];	
	}
return self;
}
// ************************************************************************************************
-(void)		dealloc
{
[super dealloc];
}
// ************************************************************************************************
-(void)		addPartial:(float)freq gain:(float)gain
{
if(numberPartials>=WXDSBasicAdditiveSynthesisMAXPARTIALS)   return;

tableIndex[numberPartials]=0;
partialFreq[numberPartials]=freq;
partialGain[numberPartials]=gain;
tableIncrement[numberPartials]=freq*waveTableSize/44100.0;


partialFreqDelta[numberPartials]=0;
partialFreqCountDown[numberPartials]=0;
partialGainDelta[numberPartials]=0;
partialGainCountDown[numberPartials]=0;

numberPartials++;
}
// ************************************************************************************************
-(void)		setGainChange:(int)partial gain:(float)gain steps:(int)steps
{
partialGainCountDown[partial]=steps;
partialGainDelta[partial]=(gain-partialGain[partial])/(float)steps;
}
// ************************************************************************************************
-(void)		setFreqChange:(int)partial freq:(float)freq steps:(int)steps
{
partialFreqCountDown[partial]=steps;
partialFreqDelta[partial]=(freq-partialFreq[partial])/(float)steps;
}
// ************************************************************************************************
-(OSStatus)		audioCallbackOnDevice:(AudioBufferList*)ioData bus:(UInt32)bus frame:(UInt32)inNumFrames time:(AudioTimeStamp*)timeStamp
{
if(!isActive) return [self RenderBlank:ioData bus:bus frame:inNumFrames];
UInt32 i;

float* out1 =(float*)   ioData->mBuffers[0].mData;
float* out2 =(float*)   ioData->mBuffers[1].mData;
float   v1;
int t;

for (i=0; i<inNumFrames; ++i) 
	{
	v1=0;
	for(t=0;t<numberPartials;t++)
		{

		v1=v1+waveTable[tableIndex[t]]*partialGain[t];
		tableIndex[t]=tableIndex[t]+tableIncrement[t];
		tableIndex[t]=(tableIndex[t] % waveTableSizeAsInteger);
		
		
		if(partialFreqCountDown[t]>0)
			{
			partialFreq[t]+=partialFreqDelta[t];
			tableIncrement[t]=partialFreq[t]*waveTableSize/44100.0;
			partialFreqCountDown[t]--;
			}
			
		if(partialGainCountDown[t]>0)
			{
			partialGain[t]+=partialGainDelta[t];
			partialGainCountDown[t]--;
			}			
		}
		
	v1=v1/(float)numberPartials;
		
	*out1++ =v1;
	*out2++ =v1;	
	}

// ************************************************************************************************

}

@end
