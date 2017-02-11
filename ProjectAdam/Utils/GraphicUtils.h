//
//  GraphicUtils.h
//  ProjectAdam
//
//  Created by shizhan on 2017/2/1.
//  Copyright © 2017年 ___GUSTPLUS___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef struct Color
{
    float red;
    float green;
    float blue;
} Color;

Color ColorMake(CGFloat red, CGFloat green, CGFloat blue);

@interface CircleData : NSObject

@property(assign, nonatomic) CGFloat lineWidth;
@property(assign, nonatomic) CGPoint center;
@property(assign, nonatomic) CGFloat radius;
@property(assign, nonatomic) Color color;
@property(assign, nonatomic) NSInteger startAngle;
@property(assign, nonatomic) NSInteger endAngle;

@end

@interface GraphicUtils : NSObject

+(void)DrawCircleSlide:(CircleData *)data withContext:(CGContextRef) context withLineWidth:(CGFloat)width withColor:(Color) color;

+(void)DrawCircle:(CircleData *)data withContext:(CGContextRef) context withColor:(Color) color withLineWidth:(CGFloat) lineWidth;

+(void)DrawCircleSlider:(CircleData *)data withContext:(CGContextRef) context;

@end
