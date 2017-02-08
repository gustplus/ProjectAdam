//
//  GraphicUtils.m
//  ProjectAdam
//
//  Created by shizhan on 2017/2/1.
//  Copyright © 2017年 ___GUSTPLUS___. All rights reserved.
//

#import "GraphicUtils.h"
#import "MathUtils.h"
#import "CircleSlideData.h"

Color ColorMake(CGFloat red, CGFloat green, CGFloat blue)
{
    Color c = {red, green, blue};
    return c;
}

@implementation GraphicUtils

+(void)DrawCircleSlide:(CircleSlideWrapper *)data withContext:(CGContextRef) context withLineWidth:(CGFloat)lineWidth withColor:(Color) color
{
    CGContextBeginPath(context);
    NSUInteger startAngle = [data getStartAngle];
    NSUInteger endAngle = [data getEndAngle];
    
    if(startAngle == endAngle)
    {
        endAngle += 1;
    }
    CGContextAddArc(context, data.center.x, data.center.y, data.radius, ANGLE_TO_RADIUS(startAngle), ANGLE_TO_RADIUS(endAngle), 0);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetRGBStrokeColor(context, color.red, color.green, color.blue, 1);
    CGContextSetLineWidth(context, lineWidth);
    CGContextStrokePath(context);

}

+(void)DrawCircle:(CircleSlideWrapper *)data withContext:(CGContextRef) context withColor:(Color) color withLineWidth:(CGFloat) lineWidth
{
    CGContextSetRGBStrokeColor(context, color.red, color.green, color.blue, 1);
    CGContextSetLineWidth(context, lineWidth);
    CGContextStrokeEllipseInRect(context, CGRectMake(data.center.x - data.radius, data.center.y - data.radius, data.radius * 2, data.radius * 2));
    CGContextStrokePath(context);
}


+(void)DrawCircleSlider:(CircleSlideWrapper *)data withContext:(CGContextRef) context
{
    CGContextBeginPath(context);
    NSUInteger startAngle = [data getStartAngle];
    NSUInteger endAngle = [data getEndAngle];
    
    if(startAngle == endAngle)
    {
        endAngle += 1;
    }
    CGContextAddArc(context, data.center.x, data.center.y, data.radius, ANGLE_TO_RADIUS(startAngle), ANGLE_TO_RADIUS(endAngle), 0);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetRGBStrokeColor(context, data.color.red, data.color.green, data.color.blue, 1);
    CGContextSetLineWidth(context, data.lineWidth);
    CGContextStrokePath(context);

}

@end
