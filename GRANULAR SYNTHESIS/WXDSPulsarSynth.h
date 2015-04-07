// ******************************************************************************************
//  WXDSPulsarSynth.h
//  Created by Paul Webb on Tue Jan 04 2005.
// ******************************************************************************************
// ABOUT PULSAR SYNTHESIS   ref:microsound book page 137
// -----------------------------------------------------
//
// pulsar has brief burst of energy followe by silence
// p=d+s where
//		p is pulsar fundimental freq
//		d is grain duration
//		s is silence
//
//		p,d,s can change (p often constant) - repetition of this is a Pulsar Train
//		d : s (duty ratio - sound to silence ratio)
//
//
//
// ******************************************************************************************
#import <Foundation/Foundation.h>
#import "WXDSGranularBasic.h"
// ******************************************************************************************

@interface WXDSPulsarSynth : WXDSGranularBasic {

float   psamples,dsamples;
float   vangle1,vangle2;
}



@end
