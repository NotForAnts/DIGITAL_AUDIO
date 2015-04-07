// ******************************************************************************************
//  WXDSSoundInputSystem.h
//  Created by Paul Webb on Sun Jan 09 2005.
// ******************************************************************************************

#import "WXDSSoundInputSystem.h"


// ************************************************************************************************
OSStatus    InputProc(void* inRefCon,
										AudioUnitRenderActionFlags* ioActionFlags,
										AudioTimeStamp* inTimeStamp,
										UInt32  inBusNumber,
										UInt32  inNumFrames, 
										AudioBufferList* ioData);
// ************************************************************************************************
OSStatus    InputProc(void* inRefCon,
										AudioUnitRenderActionFlags* ioActionFlags,
										AudioTimeStamp* inTimeStamp,
										UInt32  inBusNumber,
										UInt32  inNumFrames, 
										AudioBufferList* ioData)
										
{
id obj = (id)inRefCon; 
return [obj doRenderAudioIn:ioActionFlags p2:inTimeStamp p3:inBusNumber p4:inNumFrames p5:ioData];
}
// ************************************************************************************************


@implementation WXDSSoundInputSystem
// ************************************************************************************************
-(id)		init
{
if(self=[super init])
	{
	sendPlotter=NO;
	mInputDevice=[[WXDSAudioDevice alloc]init]; 
	mOutputDevice=[[WXDSAudioDevice alloc]init]; 
	[self SetupAUHAL:0];
	}
return self;	
}

// ************************************************************************************************
-(void)		start
{
AudioOutputUnitStart(mInputUnit); //Start pulling for audio data
mFirstInputTime = -1;
mFirstOutputTime = -1;
}
// ************************************************************************************************
-(void)		stop
{
AudioOutputUnitStop(mInputUnit);
mFirstInputTime = -1;
mFirstOutputTime = -1;
}
// ************************************************************************************************
-(OSStatus) SetupAUHAL:(AudioDeviceID)inputDevice
{
UInt32 i;
OSStatus err = noErr;
Component comp;
ComponentDescription desc;

desc.componentType = kAudioUnitType_Output;
desc.componentSubType = kAudioUnitSubType_HALOutput;
desc.componentManufacturer = kAudioUnitManufacturer_Apple;
desc.componentFlags = 0;
desc.componentFlagsMask = 0;
	
comp = FindNextComponent(NULL, &desc);			//Finds a component that meets the desc spec's
if (comp == NULL) exit (-1);
OpenAComponent(comp, &mInputUnit);				//gains access to the services provided by the component
	
UInt32 enableIO;
	

//ENABLE IO (INPUT)
//You must enable the Audio Unit (AUHAL) for input and disable output 
//BEFORE setting the AUHAL's current device.
//Enable input on the AUHAL -------------------------------------------------------------------		

enableIO = 1;
err =  AudioUnitSetProperty(mInputUnit,
							kAudioOutputUnitProperty_EnableIO,
							kAudioUnitScope_Input,
							1, // input element
							&enableIO,
							sizeof(enableIO));

if(err!=noErr) fprintf(stderr, "ERROR %ld",err); 


// disable Output on the AUHAL  -------------------------------------------------------------------	
enableIO = 0;
err = AudioUnitSetProperty(mInputUnit,
						  kAudioOutputUnitProperty_EnableIO,
						  kAudioUnitScope_Output,
						  0,   //output element
						  &enableIO,
						  sizeof(enableIO));

if(err!=noErr) fprintf(stderr, "ERROR %ld",err); 


// set input device as current  -------------------------------------------------------------------

UInt32 size = sizeof(AudioDeviceID);
err = AudioHardwareGetProperty(kAudioHardwarePropertyDefaultInputDevice,
								   &size,  
								   &inputDevice);

if(err!=noErr) fprintf(stderr, "ERROR %ld",err);

[mInputDevice doInit:inputDevice isInput:YES];

//Set the Current Device to the AUHAL.
//this should be done only after IO has been enabled on the AUHAL.
err = AudioUnitSetProperty(mInputUnit,
						  kAudioOutputUnitProperty_CurrentDevice, 
						  kAudioUnitScope_Global, 
						  0, 
						  [mInputDevice getmIDPointer], 
						  sizeof(AudioDeviceID));
						  // paul says was this--> sizeof(mInputDevice.mID));
						  
if(err!=noErr) fprintf(stderr, "ERROR %ld",err); 

// add call back  --------------------------------------------------------------------------------------------

AURenderCallbackStruct inputCallback;

inputCallback.inputProc =(void*)InputProc;
inputCallback.inputProcRefCon = self;
err = AudioUnitSetProperty(mInputUnit, 
						  kAudioOutputUnitProperty_SetInputCallback, 
						  kAudioUnitScope_Global,
						  0,
						  &inputCallback, 
						  sizeof(inputCallback));

if(err!=noErr) fprintf(stderr, "ERROR %ld",err); 

// set buffers --------------------------------------------------------------------------------------------
UInt32 bufferSizeFrames,bufferSizeBytes,propsize;

AudioStreamBasicDescription asbd;			
Float64 rate=0;

//Get the size of the IO buffer(s)
UInt32 propertySize = sizeof(bufferSizeFrames);
err = AudioUnitGetProperty(mInputUnit, kAudioDevicePropertyBufferFrameSize, kAudioUnitScope_Global, 0, &bufferSizeFrames, &propertySize);
bufferSizeBytes = bufferSizeFrames * sizeof(Float32);

//Get the Stream Format (client side)
propertySize = sizeof(asbd);
err = AudioUnitGetProperty(mInputUnit, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Output, 1, &asbd, &propertySize);	

// We must get the sample rate of the input device and set it to the stream format of AUHAL
propertySize = sizeof(Float64);
AudioDeviceGetProperty(*[mInputDevice getmIDPointer], 0, 1, kAudioDevicePropertyNominalSampleRate, &propertySize, &rate);
asbd.mSampleRate =rate;

//Set new stream format to AUHAL
propertySize = sizeof(asbd);
err = AudioUnitSetProperty(mInputUnit, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Output, 1, &asbd, propertySize);

//calculate number of buffers from channels
propsize = offsetof(AudioBufferList, mBuffers[asbd.mChannelsPerFrame]);

//malloc buffer lists
mInputBuffer = (AudioBufferList *)malloc(propsize);
mInputBuffer->mNumberBuffers = asbd.mChannelsPerFrame;

//pre-malloc buffers for AudioBufferLists
for(i =0; i< mInputBuffer->mNumberBuffers ; i++) {
	mInputBuffer->mBuffers[i].mNumberChannels = 1;
	mInputBuffer->mBuffers[i].mDataByteSize = bufferSizeBytes;
	mInputBuffer->mBuffers[i].mData = malloc(bufferSizeBytes);
}

if(err!=noErr) fprintf(stderr, "ERROR %ld",err); 

//Alloc ring buffer that will hold data between the two audio devices
mBuffer = [[WXDSAudioRingBuffer alloc]init];	
[mBuffer Allocate:asbd.mChannelsPerFrame bytesPerFrame:asbd.mBytesPerFrame capacityFrames:bufferSizeFrames * 20];

err = AudioUnitInitialize(mInputUnit);

if(err!=noErr) fprintf(stderr, "ERROR %ld",err);
return err;
}
// ************************************************************************************************
-(WXDSAudioDevice*) getOutputDevice			{		return mOutputDevice;		}
-(WXDSAudioDevice*) getInputDevice			{		return mInputDevice;		}
-(AudioBufferList*) getBuffer				{		return mInputBuffer;		}
-(WXDSAudioRingBuffer*) getRingBuffer		{		return mBuffer;				}
-(void)		setPlotterNotify:(BOOL)state	{		sendPlotter=state;			}
// ************************************************************************************************
-(OSErr)	doRenderAudioIn:(AudioUnitRenderActionFlags*)ioActionFlags
										p2:(AudioTimeStamp*)inTimeStamp
										p3:(UInt32) inBusNumber
										p4:(UInt32) inNumFrames
										p5:(AudioBufferList*)ioData
{
OSStatus err = noErr;

if (mFirstInputTime < 0.)   mFirstInputTime = inTimeStamp->mSampleTime;
//Get the new audio data
err= AudioUnitRender(mInputUnit,ioActionFlags,inTimeStamp,inBusNumber,inNumFrames, mInputBuffer);

//[mBuffer Store:mInputBuffer nFrames:inNumFrames frameNumber:(SInt64)(inTimeStamp->mSampleTime)];
if(sendPlotter) 
	[[NSNotificationCenter defaultCenter]   postNotificationName:@"plotWave" object:self];	

return err;										
}
// ************************************************************************************************



@end
