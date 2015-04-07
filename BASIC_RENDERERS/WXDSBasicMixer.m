// ***************************************************************************************
//  WXDSBasicMixer
//  Created by Paul Webb on Sun Mar 27 2005.
// ***************************************************************************************

#import "WXDSBasicMixer.h"


@implementation WXDSBasicMixer

// ************************************************************************************************
-(id)   init
{
if(self=[super init])
	{
	int t;
	for(t=0;t<32;t++)
		inputActive[t]=YES;
		
	mixRenderers=[[NSMutableArray alloc]init];
	}
return self;
}
// ************************************************************************************************
-(void) dealloc
{
[mixRenderers release];
[super dealloc];
}

// ************************************************************************************************
-(void) printInfo
{
int t,size=[mixRenderers count];
printf("NUMBER %d\n",size);
for(t=0;t<size;t++)
	{
	printf("Channel %d ",t);
	if(inputActive[t]) printf("ON\n"); else printf("OFF\n");
	}
}
// ************************************************************************************************
-(void) setInputActive:(int)index state:(BOOL)state
{
inputActive[index]=state;
}
// ************************************************************************************************
-(int)  count
{
return [mixRenderers count];
}
// ************************************************************************************************
-(id)   objectAtIndex:(int)index
{
return [mixRenderers objectAtIndex:index];
}
// ************************************************************************************************
-(void) removeRenderer:(WXDSRenderBase*)renderer
{
[mixRenderers removeObject:renderer];
}
// ************************************************************************************************
-(void) addToMix:(WXDSRenderBase*)renderer
{
[mixRenderers addObject:renderer];
}
// ************************************************************************************************
-(void) replaceRenderAtIndex:(int)index withRender:(WXDSRenderBase*)renderer
{
[mixRenderers replaceObjectAtIndex:index withObject:renderer];
}
// ************************************************************************************************
-(OSStatus)		audioCallbackOnDevice:(AudioBufferList*)ioData bus:(UInt32)bus frame:(UInt32)inNumFrames time:(AudioTimeStamp*)timeStamp
{
if(!isActive) return [self RenderBlank:ioData bus:bus frame:inNumFrames];

UInt32 i;
int t,size=[mixRenderers count],numberActive=0;
for(t=0;t<size;t++) if(inputActive[t]) numberActive++; 
if(size==0 || numberActive==0) return [self RenderBlank:ioData bus:bus frame:inNumFrames];


float   *out1,*out2,fsize=0;

// zero everything
for (i=0; i<inNumFrames; ++i) 
	total1[i]=total2[i]=0;

// sum up for each renderer
for(t=0;t<size;t++)
	{
	if(inputActive[t])
		{
		fsize=fsize+1.0;
		[[mixRenderers objectAtIndex:t]audioCallbackOnDevice:ioData bus:bus frame:inNumFrames time:timeStamp];

		out1 =(float*) ioData->mBuffers[0].mData;
		out2 =(float*) ioData->mBuffers[1].mData;

		for (i=0; i<inNumFrames; ++i) 
			{
			total1[i]+=*out1++;
			total2[i]+=*out2++;
			}
		}
	}

out1 =(float*) ioData->mBuffers[0].mData;
out2 =(float*) ioData->mBuffers[1].mData;
for (i=0; i<inNumFrames; ++i) 
	{
	*out1++ = total1[i]/fsize;
	*out2++ = total2[i]/fsize;
	}
	
return noErr;
}

// ************************************************************************************************


@end
