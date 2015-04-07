// *********************************************************************************************
//  WXDSFastFourierTransform.m
//  Created by Paul Webb on Thu Jan 06 2005.
// *********************************************************************************************
#import "WXDSFastFourierTransform.h"
// *********************************************************************************************
@implementation WXDSFastFourierTransform


// *********************************************************************************************
-(id)   init
{
if(self=[super init])
	{
	// Set the size of FFT.
	log2n = 10;                     // N is 10.
	nSize = 1 << log2n;					// n is 2^10.
      
	stride = 1;
	nOver2 = nSize / 2;                // half of n as real part and imag part.
      
	// Allocate memory for the input operands and check its availability,
	// use the vector version to get 16-byte alignment.
	A.realp = ( float* ) malloc ( nOver2 * sizeof ( float ) );
	A.imagp = ( float* ) malloc ( nOver2 * sizeof ( float ) );
	obtainedReal = ( float* ) malloc ( nSize * sizeof ( float ) );
	  
	// Set up the required memory for the FFT routines and check its availability.
	setupReal = create_fftsetup ( log2n, FFT_RADIX2);
	index1=0;
	index2=0;
	counter=0;
	sampleSize=nSize;
	numberFreqs=nSize;	
	sampleWindow1=malloc(sampleSize*sizeof(float));
	sampleWindow2=malloc(sampleSize*sizeof(float));	
	
	[self setWindowCurves];					
	}
return self;
}
// *********************************************************************************************
-(void) dealloc
{
destroy_fftsetup ( setupReal );
free ( obtainedReal );
free ( A.realp );
free ( A.imagp );
free(HAMMING);
free(BARTLETT);
free(HANNING);
free(BLACKMAN);
free(sampleWindow1);
free(sampleWindow2);

[super dealloc];
}
// *********************************************************************************************
-(void)		setWindowCurves
{
HAMMING=malloc(sampleSize*sizeof(float));
BARTLETT=malloc(sampleSize*sizeof(float));
HANNING=malloc(sampleSize*sizeof(float));
BLACKMAN=malloc(sampleSize*sizeof(float));	


int m = sampleSize/2;
int n;
float r=3.1415926535898/(float)m;

for(n=-m;n<m;n++)			HAMMING[n+m]=0.54 + 0.46*cos(n*r);
for(n=0;n<sampleSize;n++)   BARTLETT[n]= 1.0 - fabs(n - m)/m;
for(n=-m;n<m;n++)			BLACKMAN[m + n] = 0.42 + 0.5*(float)cos(n*r) + 0.08f*(float)cos(2*n*r);


r = 3.1415926535898/(m+1);
for(n=-m;n<m;n++)			HANNING[m+n]=0.5f + 0.5f*(float)cos(n*r);
}

// *********************************************************************************************
// this returns theBands float array which has calculated bands for the spectrum analysis
// *********************************************************************************************
-(float*)		calculateBands
{
float   *theData;
float   v1,v2; 
int t,clevel=0,numberPlots,quantizePlots;	
quantizePlots=1;
theData=[self getReal];	
numberPlots=[self numberFreqsChecked];
for(t=0;t<numberPlots;t+=(quantizePlots*2))
	{
	v1=theData[t];
	v2=theData[t+1];
	theBands[clevel]=sqrt(v1*v1+v2*v2);
	clevel++;
	}
	

return theBands;
}
// *********************************************************************************************
-(OSStatus)		filterChunk:(float*)ioData frame:(UInt32)inNumFrames
{
UInt32 i;

for(i=0;i<inNumFrames;i++)
	{
	if(counter>nOver2)
		{
		sampleWindow2[index2]=ioData[i];
		index2++; 

		if(index2>=sampleSize) 
			{
			[self analise:sampleWindow2];
			index2=0;
			}	
		}
	else	counter++;	
		
	sampleWindow1[index1]=ioData[i];
	index1++; 
	if(index1>=sampleSize) 
		{
		[self analise:sampleWindow1];
		index1=0;
		}
	}
return noErr;
}
// *********************************************************************************************
-(float*) filter:(float)input
{
if(counter>nOver2)
	{
	sampleWindow2[index2]=input;
	index2++; 

	if(index2>=sampleSize) 
		{
		[self analise:sampleWindow2];
		index2=0;
		}	
	}
else	counter++;	
	
sampleWindow1[index1]=input;
index1++; 
if(index1>=sampleSize) 
	{
	[self analise:sampleWindow1];
	index1=0;
	}
	

return 0;
}

// *********************************************************************************************
-(float*)   getReal
{
return obtainedReal;
}
// *********************************************************************************************
-(int)		numberFreqsChecked
{
return nOver2;
}
// *********************************************************************************************
-(float*)  analise:(float*)originalReal
{
int i;
//for(i=0;i<sampleSize;i++)   originalReal[i]= originalReal[i]*BARTLETT[i];



// Look at the real signal as an interleaved complex vector by casting it.
// Then call the transformation function ctoz to get a split complex vector,
// which for a real signal, divides into an even-odd configuration.
ctoz ( ( COMPLEX * ) originalReal, 2, &A, 1, nOver2 );


fft_zrip ( setupReal, &A, stride, log2n, FFT_FORWARD );		// Carry out a Forward FFT transform.
//fft_zrip ( setupReal, &A, stride, log2n, FFT_INVERSE );   // Carry out a Inverse FFT transform.

// Verify correctness of the results, but first scale it by 2n.
scale = (float)1.0/2.0;///(2*n);
//vsmul( A.realp, 1, &scale, A.realp, 1, nOver2 );
//vsmul( A.imagp, 1, &scale, A.imagp, 1, nOver2 );

// The output signal is now in a split real form.  Use the function ztoc to get a split real vector.
ztoc ( &A, 1, ( COMPLEX * ) obtainedReal, 2, nOver2 );

//printf("DONE ANAL - send notification\n");
[[NSNotificationCenter defaultCenter]   postNotificationName:@"Analised" object:self];	  
return obtainedReal;
}
// *********************************************************************************************

@end
