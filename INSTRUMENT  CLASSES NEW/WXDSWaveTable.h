// ******************************************************************************************
//  WXDSWaveTable
//  Created by Paul Webb on Sun Aug 14 2005.
// ******************************************************************************************


#import <Foundation/Foundation.h>
#include <stdio.h>
#import "WXUsefullCode.h"

#define CHUNK_THRESHOLD 5000000  // 5 Mb
#define CHUNK_SIZE 1024          // sample frames
// ******************************************************************************************

@interface WXDSWaveTable : NSObject {

float		*theWave;
float		theSample;
double		waveIndex,waveIncrement,waveLength,waveLengthEndIndex;


FILE *fd;
float *lastOutput;
BOOL chunking;
BOOL finished;
BOOL interpolate;
BOOL byteswap;
unsigned long fileSize;
unsigned long bufferSize;
unsigned long dataOffset;
unsigned int channels;
long chunkPointer;
//STK_FORMAT dataType;
float fileRate;
float gain;
float time;
float rate;
}

-(void)		loadWaveOfName:(char*)fileName;
-(void)		readData:(unsigned long) index;
-(BOOL)		finished;
-(void)		freeWave;
-(void)		gotoStartOfWave;
-(float)	getSize;
-(void)		setWave:(float*)wave;
-(void)		setFrequency:(float)f;
-(void)		setFrequencyForWave:(float)aFrequency;
-(void)		addPhaseOffset:(float)anAngle;
-(float)	tick;
-(float)	tickTillEnd;

@end
