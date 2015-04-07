// ******************************************************************************************
//  WXReverbMoorer
//
//  Created by Paul Webb on Thu Dec 30 2004.
//  REVERB bsed on some pdf I found on internet
//  paul webb july 2004
//  designing reverbs is an "art" based on using different types of filters
// ******************************************************************************************
#import <Foundation/Foundation.h>
#import "WXLowPass2.h"
#import "WXFilterBasicDelayTap.h"
#import "WXFilterBase.h"
// ******************************************************************************************
@interface WXReverbMoorer : WXFilterBase {

UInt32		msize,count;
float		fgain1,fgain2,fgain3,fFeedBack,xnAP,dAP;
float		ofgain1,ofgain2,ofgain3;
UInt32		fdelay1,fdelay2,fdelay3,fdelay4,fdelay5,fdelay6;
UInt32		ofdelay1,ofdelay2,ofdelay3,ofdelay4,ofdelay5,ofdelay6;
float		fdelayAP,cinput;
float		LPFa0,LPFb1;
float		SHFa0,SHFa1,SHFb1,SHFx1,SHFin,SHFy1,SHFout;
float		*tap1,*tap2,*tap3,*tap4,*tap5,*tap6,*buffer7;
float		*bufferx,*buffery;


float			d1,d2,d3,d4,d5,d6,xn1;

WXLowPass2		*lowPass1,*lowPass2,*lowPass3,*lowPass4,*lowPass5,*lowPass6;
}


-(void)		setMainFeedBack:(float)fb;
-(void)		setDelayOfSix:(int)which delay:(UInt32)delay;
-(void)		setFilterGain:(int)which gain:(float)gain;
-(float)	filter:(float)input;


@end
