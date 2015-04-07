// ************************************************************************************************
//  WXFilterBiQuad.h
//  Created by Paul Webb on Wed Dec 29 2004.
// ************************************************************************************************
// set resonance
//  This method determines the filter coefficients corresponding to
//    two complex-conjugate poles with the given \e frequency (in Hz)
//   and \e radius from the z-plane origin.  If \e normalize is true,
//   the filter zeros are placed at z = 1, z = -1, and the coefficients
//   are then normalized to produce a constant unity peak gain
//   (independent of the filter \e gain parameter).  The resulting
//   filter frequency response has a resonance at the given \e
//  frequency.  The closer the poles are to the unit-circle (\e radius
//  close to one), the narrower the resulting resonance width.

//  SET NOTCH
// This method determines the filter coefficients corresponding to
//    two complex-conjugate zeros with the given \e frequency (in Hz)
//    and \e radius from the z-plane origin.  No filter normalization
//    is attempted.
	
// ************************************************************************************************
#import <Foundation/Foundation.h>
#import "WXFilter.h"
// ************************************************************************************************
@interface WXFilterBiQuad : WXFilter {

BOOL	resoNormalise;
float   resoFreq,resoRadius,notchFreq,notchRadius;
}

-(id)		initFilter;
	
	
-(void)		setResonanceFreq:(float)frequency;
-(void)		setResonanceRadius:(float)radius;	
-(void)		setResonance:(float)frequency radius:(float)radius normalise:(BOOL)normalize;
-(void)		setNotchFreq:(float)frequency;
-(void)		setNotchRadius:(float)radius;	
-(void)		setNotch:(float)frequency radius:(float)radius;
-(void)		setEqualGainZeroes;
-(void)		setGain:(float)theGain;
-(float)	filter:(float)sample;

@end
