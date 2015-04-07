// ***************************************************************************************
//  WXDSExpWhiteNoiseRythmicsOne
//  Created by Paul Webb on Sun Sep 18 2005.
// ***************************************************************************************
#import "WXDSExpWhiteNoiseRythmicsOne.h"


@implementation WXDSExpWhiteNoiseRythmicsOne

// ************************************************************************************************
-(id)		init
{
if(self=[super init])
	{
	[self setMasterPan:0.5];
	isActive=YES;
	resolution=1;
	counter=0;
	patternRateCounter=0;
	patternCounter=0;
	currentPattern=0;
	patternGain=0.0;
	hihatCounter=0;
	patternRate=400*16;
	
	pattern[0]=[[NSMutableString alloc]initWithString:@"x-*-M--*x------*x-*-+--*X--w---*"];
	pattern[1]=[[NSMutableString alloc]initWithString:@"Xx-----M*x---x*-------++X-----w---"];
	pattern[2]=[[NSMutableString alloc]initWithString:@"wZ*x*x*-Zw---MMMx-----++XxXx--x+++x+----x-x---X"];
	pattern[3]=[[NSMutableString alloc]initWithString:@"*Z---*z*z---xXZ----+X+xZ-w--+*---*Z*Z*z--xXxX--xZ-*--M--Zx--"];
	
	patternLength=[pattern[currentPattern] length];
	bandPass=[[WXSPKitBWBandPassFilter alloc]init];
	[bandPass setCenterFreqAndBW:100 width:60];	
	reverb=[[WXFilterJohnChowningReverb alloc]initFilter:2.2];
	comb=[[WXCombFilterFeedBack alloc]initComb:44100 delay:13];
	[comb setFStrength:0.89];
	
	filterSeries=[[WXDSFilterSeries alloc]init];
	[filterSeries addObject:bandPass];
	//[filterSeries addObject:comb];
	//[filterSeries addObject:reverb];
	
	[self setDeltas:1.62636191114421113646 
		d2:0.00000591641978933724 d3:-0.00000001702812595130 
		d4: 1.52534652831449180077 d5:-0.00000002063911918564];

	[self setEvery:8];
	
	envelopeMaker=[[WXDSEnvelopeTableMaker alloc]init];
	envelopeShape=[envelopeMaker makeThreeStageTriangleEnvelope:1000 r1:0 r2:0.02 flat:400];
	}
return self;
}
// ************************************************************************************************
-(void)		setResolution:(int)r			{	resolution=r;			}
-(void)		setPatternGain:(float)v			{   patternGain=v;			}
// ************************************************************************************************
-(void)		usePattern:(int)p				
{   
currentPattern=p;
patternLength=[pattern[currentPattern] length];
patternRateCounter=0;
patternCounter=0;
}
// ************************************************************************************************
-(void)			setEvery:(int)v
{
resetEvery=v;
resetCount=resetEvery;
}
// ************************************************************************************************
-(void)			setDeltas:(float)d1 d2:(float)d2 d3:(float)d3 d4:(float)d4 d5:(float)d5
{
delta1=d1;
delta2=d2;
delta3=d3;
delta4=d4;
delta5=d5;

deltaStart1=delta1;
deltaStart2=delta2;
deltaStart4=delta4;
}
// ************************************************************************************************
-(void)		doPattern
{
patternRateCounter++;
if(patternRateCounter % patternRate !=0)  return;

char c=[pattern[currentPattern] characterAtIndex:patternCounter];

if(c=='x')  [self setWhiteFilter:7300 bw:1.0 gain:0.3 pan:0.1];
if(c=='X')  [self setWhiteFilter:11300 bw:1.0 gain:0.31 pan:0.7];
if(c=='*')  [self setWhiteFilter:130 bw:12.0 gain:4.51 pan:0.0];
if(c=='+')  [self setWhiteFilter:7000 bw:800.0 gain:0.11 pan:0.1];
if(c=='M')  [self setWhiteFilter:1600 bw:220.0 gain:0.11 pan:0.2];
if(c=='w')  [self setWhiteFilter:5000 bw:4900.0 gain:0.01 pan:0.4];
if(c=='Z')  [self setWhiteFilter:5000 bw:4900.0 gain:0.01 pan:0.5];
//if(c=='-')  [self setWhiteFilter:5000 bw:4900.0 gain:0.0 pan:0.5];

patternCounter++;
if(patternCounter>=patternLength) patternCounter=0;

return;

if(patternCounter==1)   [self setWhiteFilter:3300 bw:1.0 gain:2.0];
if(patternCounter==32)  [self setWhiteFilter:130 bw:16.0 gain:7.0];
if(patternCounter==35)  [self setWhiteFilter:100 bw:4.0 gain:0.4];
if(patternCounter==40)  [self setWhiteFilter:7000 bw:800.0 gain:0.4];
if(patternCounter==47)  [self setWhiteFilter:100 bw:4.0 gain:0.4];


}
// ************************************************************************************************
-(void)		setWhiteFilter:(float)centre bw:(float)bw gain:(float)gain pan:(float)pan
{
[bandPass setCenterFreq:centre];	
[bandPass setBandWidth:bw];	
[self setMasterGain:gain*patternGain];	
[self setMasterPan:pan];
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

resetCount--;
if(resetCount<=0)
	{
	resetCount=resetEvery;
	delta1=deltaStart1;
	delta2=deltaStart2;
	delta4=deltaStart4;
	if(doPanShift)
		{
		origPan*=-1.0;
		panShift*=-1.0;
		}
	masterPan=origPan;	
	}


for (i=0; i<inNumFrames; ++i) 
	{
	[self doPattern];
	
	if( counter % resolution ==0)   currentSample=-1.0+random()%60000/30000.0;
	counter++;
	theSample= currentSample;
	theSample*=masterGain;	
	
	if(sin(degree1)>sin(degree2)) leftSample=1.0; else leftSample=-1.0;
	//sample2 = leftSample*envelopeShape[counter % 1000];
	

	hihatCounter++;
	if(hihatCounter>patternRate)		hihatCounter=0;
	if(hihatCounter<patternRate/2)		sample2=leftSample*0.001; else sample2=0;

	

	degree2+=delta4;
	degree1+=delta1;
	delta1+=delta2;
	delta2+=delta3;
	delta4+=delta5;	


	if(filterSeries!=nil) theSample=[filterSeries filter:theSample];
	
	
	*out1++ = (theSample*panRight)+sample2;
	*out2++ = (theSample*panLeft)+sample2;
	
	}
	
return noErr;
}
// ************************************************************************************************


@end
