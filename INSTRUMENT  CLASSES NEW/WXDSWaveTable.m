// ******************************************************************************************
//  WXDSWaveTable
//  Created by Paul Webb on Sun Aug 14 2005.
// ******************************************************************************************

#import "WXDSWaveTable.h"


@implementation WXDSWaveTable

// ******************************************************************************************
-(id)   init
{
if(self=[super init])
	{
	waveIndex=0;
	waveLength=44100.0;
	waveLengthEndIndex=waveLength-1.0;
	waveIncrement=220;
	}
return self;
}
// ******************************************************************************************
-(void)		freeWave							{   free(theWave);			}
-(void)		setWave:(float*)wave				{   theWave=wave;			}
-(void)		setFrequency:(float)f				{	waveIncrement=f;		}
-(BOOL)		finished							{   return finished;		}
-(float)	getSize								{   return waveLength;		}
// ******************************************************************************************
-(void)		setFrequencyForWave:(float)aFrequency
{
// This is a looping frequency.
waveIncrement = waveLength * aFrequency / 22050.0;
}
// ******************************************************************************************
// STK rawwave files have no header and are assumed to contain a
// monophonic stream of 16-bit signed integers in big-endian byte
// order with a sample rate of 22050 Hz.
// ******************************************************************************************
-(void)		loadWaveOfName:(char*)fileName 
{
channels = 1;
dataOffset = 0;
rate = (float) 22050.0 / 44100.0;
fileRate = 22050.0;
interpolate = NO;
byteswap = NO;


unsigned long lastChannels = channels;
unsigned long samples, lastSamples = (bufferSize+1)*channels;
BOOL	result = NO;

// Try to open the file.
fd = fopen(fileName, "rb");
if (!fd) {
    printf("WvIn: Could not open or find file (%s).", fileName);
	return NO;
  }

printf("FOUND FILE FOR WAVE \n");

// find file length the old way 
SInt16 c;
int csize=0;
fseek(fd,0,SEEK_SET);
while(!feof(fd)) 
	{
	fread(&c,1, 2, fd);
	csize++;
	}
	
// close and reopen it	
fclose(fd);	
fd = fopen(fileName, "rb");
fileSize=csize/2;
bufferSize = fileSize;	
waveLength=fileSize;

if ( fmod(rate, 1.0) != 0.0 ) interpolate = YES;
chunkPointer = 0;
[self gotoStartOfWave];
[self readData:0]; 
finished = YES;

fclose(fd);
fd = 0;
waveIncrement=1.0;

return YES;
}
// ******************************************************************************************
-(void) readData:(unsigned long) index
{

long i, length = bufferSize;
bool endfile = (chunkPointer+bufferSize == fileSize);
if ( !endfile ) length += 1;

SInt16 *buf = malloc(bufferSize*sizeof(SInt16));
theWave = malloc(bufferSize*sizeof(float));

if (fseek(fd, dataOffset+(long)(chunkPointer*channels*2), SEEK_SET) == -1) return;
if (fread(buf, length*channels, 2, fd) != 2 ) return;

for(i=0;i<bufferSize;i++)
	theWave[i]=buf[i]/32150.0;

waveLength=(double)bufferSize;
waveLengthEndIndex=waveLength-1;
free(buf);

}
// ******************************************************************************************
-(void)		addPhaseOffset:(float)anAngle
{
return;
// Add a phase offset in cycles, where 1.0 = fileSize.
waveIndex += waveLength * anAngle;
if(waveIndex>=waveLengthEndIndex) waveIndex=waveIndex-waveLengthEndIndex;
}

// ******************************************************************************************
-(void)		gotoStartOfWave
{
time = (float) 0.0;
finished=NO;
waveIndex=0.0;
}
// ******************************************************************************************
-(float)	tickTillEnd
{
theSample=theWave[(int)waveIndex];
waveIndex+=waveIncrement;
if(waveIndex>=waveLengthEndIndex) 
	{
	waveIndex=waveIndex;
	finished=YES;
	}

return theSample;
}
// ******************************************************************************************
-(float)	tick
{
theSample=theWave[(int)waveIndex];

waveIndex+=waveIncrement;
if(waveIndex>=waveLengthEndIndex) waveIndex=waveIndex-waveLengthEndIndex;

return theSample;
}
// ******************************************************************************************

@end
