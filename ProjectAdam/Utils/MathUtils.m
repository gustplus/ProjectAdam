//
//  MathUtils.m
//  ProjectAdam
//
//  Created by shizhan on 2017/2/1.
//  Copyright © 2017年 ___GUSTPLUS___. All rights reserved.
//

#import "MathUtils.h"

@implementation MathUtils

+(BOOL)floatEquals:(float) f0 with:(float) f1
{
    return fabsf(f0 - f1) > 0.000001f;
}

+(NSInteger)getAngleInCGContext:(NSInteger)angle
{
    if(angle > 360)
    {
        angle = 360;
    }
    return 270 + angle;
}

+(CGFloat)distanceSquareFrom:(CGPoint) p0 To:(CGPoint) p1
{
    CGFloat px = p0.x - p1.x;
    CGFloat py = p0.y - p1.y;
    return px * px + py * py;
}

+(BOOL)isPoint:(CGPoint) p InCircleAt:(CGPoint) center WithRadius:(CGFloat) radius
{
    return [MathUtils distanceSquareFrom:p To:center] <= radius * radius;
}

+(float)clip:(float)value InRange:(float) low and:(float)high
{
    if(value > high)
    {
        value = high;
    }
    else if(value < low)
    {
        value = low;
    }
    return value;
}

+(float)linearInterpolationBetween:(float)start and:(float)end at:(float) percent
{
    percent = [MathUtils clip:percent InRange:0 and:1];
    return start + (end - start) * percent;
}

+(float)cosInterpolationBetween:(float)start and:(float)end at:(float) percent
{
    percent = (cosf(percent * M_PI) + 1) * 0.5f;
    return start + (end - start) * percent;
}

@end
