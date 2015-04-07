// ***************************************************************************************
//  WXDSExpRenderTestOne
//  Created by Paul Webb on Mon Jul 25 2005.
// ***************************************************************************************

#import "WXDSExpRenderTestOne.h"


@implementation WXDSExpRenderTestOne

// ************************************************************************************************
-(id)		initWithFreq:(double)r
{
if(self=[super initWithFreq:r])
	{
	counter=0;
	updateCounter=0;
	masterGain=3.0;
	noiseLevel=0.4;
	
	
	sineMap1=[[WXDSMapperSine alloc]initMapperSine:0.0 r2:1000.0 m1:40 m2:120];
	sineMap2=[[WXDSMapperSine alloc]initMapperSine:0.0 r2:1000.0 m1:60 m2:260];
	sineMap3=[[WXDSMapperSine alloc]initMapperSine:0.0 r2:1000.0 m1:10 m2:90];
	sineMap4=[[WXDSMapperSine alloc]initMapperSine:0.0 r2:1000.0 m1:0.96 m2:0.999];	
	sineMap5=[[WXDSMapperSine alloc]initMapperSine:0.0 r2:1000.0 m1:.2 m2:.6];
			
	calc1=[[WXCalculatorUnstable2 alloc]initWave:0.0 range2:1000.0 changePatternEvery:4 maxPatterns:4];
	//calc1=[[WXCalculatorVariedTriangleWave alloc]initWave:20 maxWaveSize:70 range1:0.0 range2:400.0 range3:300 range4:1000.0];
	
	reverb=[[WXFilterJohnChowningReverb alloc]initFilter:12.2];
	comb=[[WXCombFilterFeedBack alloc] initComb:22100 delay:100];
	bandPass=[[WXSPKitBWBandPassFilter alloc] init];
	resonator=[[WXSPKitResonator alloc] init];
	
	[comb setFStrength:0.90];
	[comb setDelay:20];
	
	[bandPass setCenterFreq:520];
	[bandPass setBandWidth:300];
	
	[resonator setCenterFreq:1280];
	[resonator setBandWidth:200];
	
	[calc1 reset];
	}
return self;
}

// ************************************************************************************************
-(void)							doTimedAction
{
updateCounter++;
if(updateCounter % 80 !=0)  return;


float   v=[calc1 doUpdate];

[bandPass setCenterFreq:v/5.0+420];
[bandPass setBandWidth:[sineMap1 map:v]];

[resonator setCenterFreq:[sineMap2 map:v]];
[resonator setBandWidth:[sineMap3 map:v]];

[comb setFStrength:[sineMap4 map:v]];

noiseLevel=[sineMap5 map:v];
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
	leftSample=sin(degree1)*0.5+sin(degree1*100)*0.5;
	leftSample+=WXUFloatRandomBetween(-noiseLevel,noiseLevel);
	
	if(counter>=6000) 
		{
		if(counter>=6010) leftSample=1.0;
		[bandPass setBandWidth:100];
		[resonator setBandWidth:100];
		degree1+=(delta1*50);
		}
		
	counter++;
	if(counter>6045) counter=0; 

	leftSample=[comb filter:leftSample];
	leftSample=[bandPass filter:leftSample];
	leftSample=[reverb filter:leftSample];
	leftSample=[resonator filter:leftSample];
	
	
	*out1++ = leftSample*masterGain*panRight;
	*out2++ = leftSample*masterGain*panLeft;
	
	
	

	degree1+=delta1;
	}
	
return noErr;
}
// ************************************************************************************************

@end
