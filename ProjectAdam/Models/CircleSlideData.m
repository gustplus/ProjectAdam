//
//  CircleSlideData.m
//  ProjectAdam
//
//  Created by shizhan on 2017/2/1.
//  Copyright © 2017年 ___GUSTPLUS___. All rights reserved.
//

#import "CircleSlideData.h"
#import "MathUtils.h"

@implementation CircleSlideData

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        self.min = 0;
        _interval = 0;
        _value= 0;
    }
    return self;

}

-(instancetype)initWithMin:(float) min AndInterval:(float) interval
{
    self = [super init];
    if(self)
    {
        self.min = min;
        self.interval = interval;
        _value = min;
    }
    return self;
}

-(void)setInterval:(float)interval
{
    if(interval < 0)
    {
        NSLog(@"interval can't less than 0, force reset to 0");
        interval = 0;
    }
    _interval = interval;
}

-(void)setValue:(float)value
{
    if(value < self.min)
    {
        _value = self.min;
    }
    else if(value > (self.min + self.interval))
    {
        _value = self.min + self.interval;
    }
    else
    {
        _value = value;
    }
    if(self.delegate && [self.delegate respondsToSelector:@selector(valueChanging:withTag:)])
    {
        [self.delegate valueChanging:_value withTag: self.tag];
    }
}

-(void)setValueEnd:(float)value
{
    self.value = value;
    if(self.delegate && [self.delegate respondsToSelector:@selector(valueChanged:withTag:)])
    {
        [self.delegate valueChanged:value withTag:self.tag];
    }
}

@end
