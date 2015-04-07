// ******************************************************************************************
//  WXFilterOnePole
//  Created by Paul Webb on Thu Dec 30 2004.
//
//  [setPole]
//  This method sets the pole position along the real-axis of the
//    z-plane and normalizes the coefficients for a maximum gain of one.
//    A positive pole value produces a low-pass filter, while a negative
//    pole value produces a high-pass filter.  This method does not
//    affect the filter \e gain value.
//
//  [setGain]
//    The gain is applied at the filter input and does not affect the
//    coefficient values.  The default gain value is 1.0.
/*
   Here's the complex "Z-plane", the one used in the pole-zero method:

                         pi/2                "|" axis: imaginary
                     __---|---__             "-" axis: real
                   _/     |     \_           (as always!)
                  /       |       \          
                 |        |        |
             pi -|--------+--------|- 0
                 |        |        |
                  \_      |      _/
                    \__   |   __/
                       ---|---
                        3/2 pi

        Imagine the frequencies to be wrapped around the unit circle. At angle
        0 we have 0Hz, at pi/2 we have samplerate/4, at pi we have
        samplerate/2, the Nyquist frequency. You shouldn't care about higher
        frequencies, since they will never appear in the signal, but anyway, at
        2pi (full cycle) we have the sampling frequency.

        So if you used sampling frequency 44100 Hz, 0 Hz would be at (1,0),
        11025 Hz at (0,1) and 22050 Hz at (-1,0). 
*/
// ******************************************************************************************
#import <Foundation/Foundation.h>
#import "WXFilter.h"



@interface WXFilterOnePole : WXFilter {

}

-(id)   initFilter:(float)thePole;
	
-(void)		clear;
-(void)		setPole:(float)thePole;
-(void)		setGain:(float)theGain;
-(void)		setB0NSO:(id)b0;
-(void)		setA1NSO:(id)a1;
-(void)		setB0:(float)b0;
-(void)		setA1:(float)a1;
-(void)		setPoleNSO:(id)thePole;
-(void)		setGainNSO:(id)theGain;
-(float)	getGain;
-(float)	lastOut;
-(float)	filter:(float)sample;

@end
