// ************************************************************************************************
//  WXFilterTwoPole
//  Created by Paul Webb on Thu Dec 30 2004.
// ************************************************************************************************
#import <Foundation/Foundation.h>
#import "WXFilter.h"
// ************************************************************************************************

@interface WXFilterTwoPole : WXFilter {


BOOL	resoNormalise;
float   resoFreq,resoRadius;
}


-(void)  clear;
-(void)  setB0:(float)b0;		
-(void)  setA1:(float)a1;		
-(void)  setA2:(float)a2;		
-(void) setResonanceFreq:(float)frequency;
-(void) setResonanceRadius:(float)radius;		
-(void)  setResonance:(float) frequency radius:(float)radius normalise:(BOOL)normalize; 
-(void)  setGain:(float)theGain;	

-(void)  setB0NSO:(id)b0;		
-(void)  setA1NSO:(id)a1;		
-(void)  setA2NSO:(id)a2;		
-(void)  setResonanceFreqNSO:(id)frequency;
-(void)  setResonanceRadiusNSO:(id)radius;		
-(void)  setGainNSO:(id)theGain;	

-(float) getGain;	
-(float) lastOut;	
-(float) filter:(float)sample;		

@end
