// ******************************************************************************************
//  WXAUGraph
//  Created by Paul Webb on Wed Dec 29 2004.
// ******************************************************************************************
#import "WXAUGraph.h"


// ******************************************************************************************
// This is the C Function which acts as the callback for all renderers added to the graph
// it should be possible to be able to have multiple AUgraphs instances that call this one function
// as importing the file means only one of them
// ************************************************************************************************
OSStatus    MyInputCallback(void* inRefCon,
										AudioUnitRenderActionFlags* ioActionFlags,
										const AudioTimeStamp* inTimeStamp,
										UInt32  inBusNumber,
										UInt32  inNumFrames, 
										AudioBufferList* ioData);
// ************************************************************************************************
OSStatus    MyInputCallback(void* inRefCon,
										AudioUnitRenderActionFlags* ioActionFlags,
										const AudioTimeStamp* inTimeStamp,
										UInt32  inBusNumber,
										UInt32  inNumFrames, 
										AudioBufferList* ioData)
										
{
id obj = (id)inRefCon; // though I guess id is just a typedef for void* so this cast should be useless...
[obj audioCallbackOnDevice:ioData bus:inBusNumber frame:inNumFrames time:inTimeStamp];
return noErr;
}	
										
// ************************************************************************************************
// AND THE CLASS IMPLEMENTATION IS HERE
// ************************************************************************************************
@implementation WXAUGraph
// ************************************************************************************************
//  constructors
// ************************************************************************************************
-(id)		init
{
if(self=[super init])
	{
	mixerTypeUsed=0;
	
	audioNodeArray=[[NSMutableArray alloc]initWithCapacity:1];
	audioUnitArray=[[NSMutableArray alloc]initWithCapacity:1];
	unitNodeNames=[[NSMutableArray alloc]initWithCapacity:1];
	renderObjectArray=[[NSMutableArray alloc]initWithCapacity:1];
	}
return self;	
}
// ******************************************************************************************
-(void) dealloc
{
[audioNodeArray release];
[audioUnitArray release];
[unitNodeNames release];
[renderObjectArray release];
[super dealloc];
}
// ************************************************************************************************
-(void)		setUpUsingDefaultDevice
{
}
// ************************************************************************************************
// where inBusCount is the number of audioUnits (or renderers) that can plug into it
// THE STEREO MIXER IS THE MORE SIMPLE MIXER
// ************************************************************************************************
-(void)		setUpUsingStereoMixer:(UInt32)inBusCount
{
OSErr		err=noErr;
NewAUGraph(&mAUGraph);
busCount    = inBusCount;

[self addNode:@"OUTPUT" type:kAudioUnitType_Output subtype:kAudioUnitSubType_DefaultOutput manufacture:kAudioUnitManufacturer_Apple];
[self addNode:@"MAINMIXER" type:kAudioUnitType_Mixer subtype:kAudioUnitSubType_StereoMixer manufacture:kAudioUnitManufacturer_Apple];

mixerTypeUsed=2;
AUGraphOpen(mAUGraph);

WXAudioUnit*  mixerPointer;
UInt32  size=sizeof(UInt32);

mixerPointer=[self unitByName:@"MAINMIXER"];
mainMixerPointer=mixerPointer;
if(mixerPointer!=0)
	{
	err=[mixerPointer AudioUnitSetProperty:kAudioUnitProperty_BusCount scope:kAudioUnitScope_Input element:0
		data:&busCount size:size];
		
	if(err!=noErr) fprintf(stderr, "set bus for mixer error %ld with buses %d\n", err,busCount);
	}
}
// ************************************************************************************************
// where inBusCount is the number of audioUnits (or renderers) that can plug into it
// ************************************************************************************************
-(void)		setUpUsing3DMixer:(UInt32)inBusCount
{
OSErr		err=noErr;
NewAUGraph(&mAUGraph);
busCount    = inBusCount;

[self addNode:@"OUTPUT" type:kAudioUnitType_Output subtype:kAudioUnitSubType_DefaultOutput manufacture:kAudioUnitManufacturer_Apple];
[self addNode:@"MAINMIXER" type:kAudioUnitType_Mixer subtype:kAudioUnitSubType_3DMixer manufacture:kAudioUnitManufacturer_Apple];

mixerTypeUsed=1;
AUGraphOpen (mAUGraph);

WXAudioUnit*  mixerPointer;
UInt32  size=sizeof(UInt32);

mixerPointer=[self unitByName:@"MAINMIXER"];
mainMixerPointer=mixerPointer;
if(mixerPointer!=0)
	{
	err=[mixerPointer AudioUnitSetProperty:kAudioUnitProperty_BusCount scope:kAudioUnitScope_Input element:0
		data:&busCount size:size];
		
	if(err!=noErr) fprintf(stderr, "set bus for mixer error %d with buses %d\n", err,busCount);
	}
}
// ************************************************************************************************
-(void)		addNode:(NSString*)idName   type:(OSType)type subtype:(OSType)subtype manufacture:(OSType)manufacture
{
OSErr					err=noErr;
ComponentDescription    cd;

WXAUNode*		newNode=[[WXAUNode alloc]init];
WXAudioUnit*	newUnit=[[WXAudioUnit alloc]init];


cd.componentFlags=0;
cd.componentFlagsMask=0;
cd.componentType=type;
cd.componentSubType=subtype;
cd.componentManufacturer=manufacture;

[newNode setNewNode:mAUGraph cd:cd];
AUGraphOpen(mAUGraph);

err=[newNode AUGraphGetNodeInfo:mAUGraph unit:newUnit];

if(err!=noErr) 
	{
	fprintf(stderr, "get unit of node error %d\n", err);
	}
else
	{
	[audioNodeArray addObject:newNode];			[newNode release];
	[audioUnitArray addObject:newUnit];			[newUnit release];
	[unitNodeNames addObject:idName];	
	}
}

// ************************************************************************************************
-(void)		connect:(NSString*)sourceID to:(NSString*)destID sourceBus:(UInt32)bus1 destBus:(UInt32)bus2
{
OSErr		err=noErr;
short sourceIndex,destIndex;
WXAUNode	*sourceNode,*destNode;

sourceIndex=[self nameExists:sourceID];
destIndex=[self nameExists:destID];

if(sourceIndex>=0 && destIndex>=0)
	{
	printf("connect: "); [self printname:sourceIndex linefeed:NO];
	printf("bus out %d to ",(int)bus1); [self printname:destIndex linefeed:NO];
	printf("bus in %d \n",(int)bus2);
	
	sourceNode=[audioNodeArray objectAtIndex:sourceIndex];
	destNode=[audioNodeArray objectAtIndex:destIndex];	
	err=[sourceNode AUGraphConnectNodeInput:mAUGraph bus1:bus1 destinationNode:destNode bus2:bus2];
	
	if(err!=noErr) fprintf(stderr, "connection error %d\n", err);
	}

}
// ************************************************************************************************
-(void)		addRenderer:(WXDSRenderBase*)renderer to:(NSString*)destID forBus:(UInt32)bus andName:(NSString*)idName
{
short		unitIndex;
OSErr		err=noErr;

unitIndex=[self nameExists:destID];
if(unitIndex>=0)
	{
	[unitNodeNames addObject:idName];
	printf("add renderer to bus %d of unit named",(int)bus);		[self printname:unitIndex linefeed:YES];
	
	[renderObjectArray addObject:renderer];
	[renderer setRenderName:idName];
	[renderer getCallBackPointer]->inputProc = MyInputCallback;
	[renderer getCallBackPointer]->inputProcRefCon =renderer;
	
	err=[[audioUnitArray objectAtIndex:unitIndex] AudioUnitSetProperty:kAudioUnitProperty_SetRenderCallback scope:kAudioUnitScope_Input 
			element:bus data:[renderer getCallBackPointer] size:sizeof (AURenderCallbackStruct)];
			
	if(err!=noErr) fprintf(stderr, "added callback error : %d\n", err);
	}
}
// ************************************************************************************************
// adding a node - specific apple type
// ************************************************************************************************
-(void)		addNodeFilter:(NSString*)idName subtype:(OSType)subtype
{
[self addNode:idName type:'aufx' subtype:subtype manufacture:kAudioUnitManufacturer_Apple];
}
// ************************************************************************************************
-(void)		addNodeStereoMixer:(NSString*)idName numBus:(UInt32)inBusCount
{
OSErr		err=noErr;
WXAudioUnit*  theUnit;

[self addNode:idName type:kAudioUnitType_Mixer subtype:kAudioUnitSubType_StereoMixer manufacture:kAudioUnitManufacturer_Apple];

AUGraphOpen(mAUGraph);
theUnit=[self unitByName:idName];
if(theUnit!=0)
	{
	err=[theUnit AudioUnitSetProperty:kAudioUnitProperty_BusCount scope:kAudioUnitScope_Input element:0
		data:&inBusCount size:sizeof(UInt32)];
		
	if(err!=noErr) 
		fprintf(stderr, "set bus for mixer error %ld with buses %d\n", err,busCount);
	else
		printf("added stereo mix with %d\n",inBusCount);
	}
}
// ************************************************************************************************
-(void)		setAllFormats
{
OSErr		err=noErr;
short		t;
AudioStreamBasicDescription theStreamFormat; 
UInt32 outSize= sizeof(theStreamFormat);

theStreamFormat.mSampleRate = 44100.0;
theStreamFormat.mFormatID = kAudioFormatLinearPCM;
theStreamFormat.mFormatFlags = kAudioFormatFlagsNativeFloatPacked  | kAudioFormatFlagIsNonInterleaved;
theStreamFormat.mBytesPerPacket = 4;        
theStreamFormat.mFramesPerPacket = 1;       
theStreamFormat.mBytesPerFrame = 4;         
theStreamFormat.mChannelsPerFrame = 2;      
theStreamFormat.mBitsPerChannel = sizeof (Float32) * 8;  
outSize = sizeof(theStreamFormat);

for(t=0;t<[audioUnitArray count];t++)
	{
	err=[[audioUnitArray objectAtIndex:t] AudioUnitSetProperty:kAudioUnitProperty_StreamFormat 
			scope:kAudioUnitScope_Input element:0 data:&theStreamFormat size:outSize];

	if(err!=noErr) fprintf(stderr, "set format error %d\n", err);
	}
}
// ************************************************************************************************
-(void)		start
{
short t;
for(t=0;t<[renderObjectArray count];t++)
	{
	[[renderObjectArray objectAtIndex:t] doReset];
	[[renderObjectArray objectAtIndex:t] doPreStart];
	}
	
AUGraphInitialize(mAUGraph);
AUGraphStart(mAUGraph);
}
// ************************************************************************************************
-(void)		stop
{
AUGraphStop(mAUGraph);
}
// ************************************************************************************************
-(void)		empty
{
}
// ************************************************************************************************
//  PARAMETER SETTINGS
// ******************************************************************************************
// gain is 0.0 to 1.0
-(void)			MixerAllGain:(Float32)busGain
{
UInt32 t;
for(t=0;t<busCount;t++)
	[self SetInputBusGain:t gain:busGain];
}
// ******************************************************************************************
-(void)			SetInputBusGain:(UInt32)bus gain:(Float32)busGain
{
if(mixerTypeUsed!=1)	return;

short		unitIndex;
Float32		db=20.0*log10(busGain);     // convert to db
if(db< -120.0)  db=-120.0;				// clamp minimum audible level at -120db

unitIndex=[self nameExists:@"MAINMIXER"];
if(unitIndex>=0)
	[[audioUnitArray objectAtIndex:unitIndex] AudioUnitSetParameter:k3DMixerParam_Gain scope:kAudioUnitScope_Input 
		element:bus value:db inFrames:0];
}
// ************************************************************************************************
//  USEFULL METHODS
// ************************************************************************************************
// prints to screen the audiounit that are installed in library
// ************************************************************************************************
-(void)		listAllUnits
{
ComponentDescription desc;
desc.componentType =kAudioUnitType_Effect;//'aufx';// kAudioUnitType_Effect; //'aufx'
desc.componentSubType = 0;
desc.componentManufacturer = 'appl';//kAudioUnitManufacturer_Apple;
desc.componentFlags = 0;
desc.componentFlagsMask = 0;
    
printf ("Found %ld Effect Audio Units\n", CountComponents(&desc));
Component theAUComponent = FindNextComponent (NULL, &desc);
while (theAUComponent != NULL)
{
		// now we need to get the information on the found component
	ComponentDescription found;
	GetComponentInfo (theAUComponent, &found, 0, 0, 0);

	printf ("%4.4s - ", (char*)&(found.componentType));
	printf ("%4.4s - ", (char*)&(found.componentSubType));
	printf ("%4.4s,", (char*)&(found.componentManufacturer));
	printf ("%ld,%ld\n", found.componentFlags, found.componentFlagsMask);
		
	theAUComponent = FindNextComponent (theAUComponent, &desc);
}
}
// ************************************************************************************************
-(void)		printname:(short)_index linefeed:(BOOL)_feed
{
const char* buffer;
buffer=[[unitNodeNames objectAtIndex:_index] UTF8String];
if(_feed)printf("%s \n",buffer); else printf("%s ",buffer);
}
// ************************************************************************************************
-(void)		listUnitsInGraph
{
}
// ************************************************************************************************
//  TREAT AS PRIVATE
// ************************************************************************************************
-(short)	nameExists:(NSString*)_findName
{
short t;
for(t=0;t<[unitNodeNames count];t++)
		if([[unitNodeNames objectAtIndex:t] isEqualToString:_findName]) return t;
	
return -1;	
}
// ************************************************************************************************
-(WXAudioUnit*)   unitByName:(NSString*)_findName
{
short t;
for(t=0;t<[unitNodeNames count];t++)
	if([[unitNodeNames objectAtIndex:t] isEqualToString:_findName]) return [audioUnitArray objectAtIndex:t];

return 0;
}
// ************************************************************************************************
@end
