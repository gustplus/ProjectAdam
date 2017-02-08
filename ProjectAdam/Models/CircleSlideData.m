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

@implementation CircleSlideWrapper

-(void)setColorWithR:(float)red G:(float)green B:(float)blue
{
    _color.red = red;
    _color.green = green;
    _color.blue = blue;
}
-(CGPoint)headPoint
{
    float angle = (self.data.value - self.data.min) / self.data.interval * 360;
    angle = 90 - angle; //translate angle to normal x-y coordinater
    float rad = ANGLE_TO_RADIUS(angle);
    float offsetX = cosf(rad) * _radius;
    float offsetY = sinf(rad) * _radius;
    return CGPointMake(_center.x + offsetX, _center.y - offsetY);
}

-(BOOL) isPointIn:(CGPoint)point
{
    CGPoint head = [self headPoint];
    return [MathUtils isPoint:point InCircleAt:head WithRadius:_lineWidth * 2];
}

-(NSInteger)pointAngle:(CGPoint)point
{
    float offsetX = point.x - _center.x;
    float offsetY = point.y - _center.y;
    float tan = offsetY / offsetX;
    float rad = atanf(tan);
    NSInteger angle = (NSInteger)RADIUS_TO_ANGLE(rad);
    if(offsetX < 0)
    {
        angle += 180;
    }
    return 90 + angle;
}

-(void)beginTouch:(CGPoint) point
{
    float val = self.data.value - self.data.min;
    self.preAngle = (NSUInteger)(val / self.data.interval * 360);
    if(self.preAngle == 0)
    {
        self.state = kStateReachBottom;
    }
    else if(self.preAngle == 360)
    {
        self.state = kStateReachTop;
    }
}

-(NSInteger)calculateFinalAngle:(NSInteger) angle
{
    if(self.state == kStateUp && angle < 90 && self.preAngle > 270)
    {
        self.state = kStateReachTop;
        angle = 360;
    }
    else if(self.state == kStateDown && (angle - self.preAngle) > 180)
    {
        self.state = kStateReachBottom;
        angle = 0;
    }
    else if(self.state == kStateReachTop)
    {
        if(angle > 270)
        {
            self.state = kStateDown;
        }
        else
        {
            angle = 360;
        }
    }
    else if(self.state == kStateReachBottom)
    {
        if(angle < 90)
        {
            self.state = kStateUp;
        }
        else
        {
            angle = 0;
        }
    }
    
    if(self.preAngle < angle)
    {
        self.state = kStateUp;
    }
    else if(self.preAngle > angle)
    {
        self.state = kStateDown;
    }
    return angle;
}

-(void)moveTouch:(CGPoint) point
{
    NSInteger angle = [self pointAngle:point];
    
    angle = [self calculateFinalAngle:angle];
    
    self.data.value = self.data.min + self.data.interval * angle / 360;
    self.preAngle = angle;
}

-(void)endTouch:(CGPoint) point
{
    NSInteger angle = [self pointAngle:point];
    
    angle = [self calculateFinalAngle:angle];
    
    [self.data setValueEnd: self.data.min + self.data.interval * angle / 360 ];
    self.state = kStateNone;
    
}

-(NSInteger)getStartAngle
{
    return [MathUtils getAngleInCGContext:0];
}

-(NSInteger)getEndAngle
{
    float val = self.data.value - self.data.min;
    NSUInteger angle = (NSUInteger)(val / self.data.interval * 360);
    return [MathUtils getAngleInCGContext:angle];
}

@end
