//
//  GraphicUtils.h
//  ProjectAdam
//
//  Created by shizhan on 2017/2/1.
//  Copyright © 2017年 ___GUSTPLUS___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class CircleSlideWrapper;

typedef struct Color
{
    float red;
    float green;
    float blue;
} Color;

Color ColorMake(CGFloat red, CGFloat green, CGFloat blue);

@interface GraphicUtils : NSObject

+(void)DrawCircleSlide:(CircleSlideWrapper *)data withContext:(CGContextRef) context withLineWidth:(CGFloat)width withColor:(Color) color;

+(void)DrawCircle:(CircleSlideWrapper *)data withContext:(CGContextRef) context withColor:(Color) color withLineWidth:(CGFloat) lineWidth;

+(void)DrawCircleSlider:(CircleSlideWrapper *)data withContext:(CGContextRef) context;

@end
