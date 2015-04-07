// ******************************************************************************************
//  WXAUGraph
//  Created by Paul Webb on Wed Dec 29 2004.
// ******************************************************************************************
//  the apple effects
//  kAudioUnitSubType_Varispeed 
//  kAudioUnitSubType_Delay 
//  kAudioUnitSubType_LowPassFilter
//  kAudioUnitSubType_HighPassFilter 
//  kAudioUnitSubType_BandPassFilter 
//  kAudioUnitSubType_HighShelfFilter
//  kAudioUnitSubType_LowShelfFilter
//  kAudioUnitSubType_ParametricEQ 
//  kAudioUnitSubType_GraphicEQ 
//  kAudioUnitSubType_PeakLimiter 
//  kAudioUnitSubType_DynamicsProcessor 
//  kAudioUnitSubType_MultiBandCompressor 
//  kAudioUnitSubType_MatrixReverb 
// ******************************************************************************************
#import <Foundation/Foundation.h>
#import "AudioToolBox/AUGraph.h"
#import "WXAudioUnit.h"
#import "WXAUNode.h"
#import "WXDSRenderBase.h"
#import "AudioUnitProperties.h"
#import "AUComponent.h"
// ******************************************************************************************

@interface WXAUGraph : NSObject {

NSMutableArray*			audioNodeArray;
NSMutableArray*			audioUnitArray;
NSMutableArray*			unitNodeNames;
NSMutableArray*			renderObjectArray;

UInt32					busCount;
AUGraph					mAUGraph;
WXAudioUnit*			mainMixerPointer;
short					mixerTypeUsed;
}



-(void)		setUpUsingDefaultDevice;
-(void)		setUpUsing3DMixer:(UInt32)inBusCount;
-(void)		setUpUsingStereoMixer:(UInt32)inBusCount;

-(void)		addNode:(NSString*)idName type:(OSType)type subtype:(OSType)subtype manufacture:(OSType)manufacture;
-(void)		connect:(NSString*)sourceID to:(NSString*)destID sourceBus:(UInt32)bus1 destBus:(UInt32)bus2;
-(void)		addRenderer:(WXDSRenderBase*)renderer to:(NSString*)destID forBus:(UInt32)bus andName:(NSString*)idName;
-(void)		addNodeFilter:(NSString*)idName subtype:(OSType)subtype;
-(void)		addNodeStereoMixer:(NSString*)idName numBus:(UInt32)inBusCount;

-(void)		setAllFormats;	
-(void)		start;
-(void)		stop;
-(void)		empty;

//  STANDARD MIXER CONTROLS
-(void)			MixerAllGain:(Float32) busGain;
-(void)			SetInputBusGain:(UInt32) bus gain:(Float32) busGain;


//  USEFULL METHODS
-(void)		printname:(short)_index linefeed:(BOOL)_feed;
-(void)		listAllUnits;
-(void)		listUnitsInGraph;

//  TREAT AS PRIVATE
-(short)		nameExists:(NSString*)_findName;
-(WXAudioUnit*)	unitByName:(NSString*)_findName;

@end
