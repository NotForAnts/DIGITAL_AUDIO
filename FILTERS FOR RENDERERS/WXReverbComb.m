// ******************************************************************************************
//  WXReverbComb
//  Created by Paul Webb on Thu Dec 30 2004.
// ******************************************************************************************
#import "WXReverbComb.h"


@implementation WXReverbComb
// ******************************************************************************************
-(id)		init
{
if(self=[super init])
	{
	short t;
	msize=44100*2;
	count=0;
	tap=malloc(msize*sizeof(float));

	// between 0 and 50 ms is 0 2205
	for(t=0;t<10;t++)
		{
		delay[t]=40+(t*t*200)+random()%4000;
		strength[t]=0.99;//1.0;//0.6+random()%490/1000;
		}
	}
return self;
}
// ******************************************************************************************
-(void)		dealloc
{
free(tap);
[super dealloc];
}
// ******************************************************************************************
-(void)		clear
{
int i;
for(i=0;i<msize;i++) tap[i]=0.0;
count=0;
}
// ******************************************************************************************
-(void)		setType1
{
delay[0]=150;	strength[0]=1.0;	
delay[1]=450;	strength[1]=1.0;
delay[2]=1250;	strength[2]=1.0;
delay[3]=3320;	strength[3]=1.0;
delay[4]=5520;	strength[4]=0.99;
delay[5]=6720;	strength[5]=0.9;
}
// ******************************************************************************************
-(float)	filter:(float)input
{
short t;
tap[count%msize]=input;

output=input;
reverbtotal=0;

for(t=0;t<6;t++)
	{
	if(count>delay[t]) reverbtotal=reverbtotal+strength[t]*tap[(count-delay[t])%msize]; 
	}
reverbtotal=reverbtotal/6.0;
output=input*1.0+reverbtotal;
tap[count%msize]=output;
	
count++;
return output;
}
// ******************************************************************************************



@end
