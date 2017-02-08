//
//  MathUtils.h
//  ProjectAdam
//
//  Created by shizhan on 2017/2/1.
//  Copyright © 2017年 ___GUSTPLUS___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define ANGLE_TO_RADIUS(angle) (((float)angle) / 180 * M_PI)
#define RADIUS_TO_ANGLE(rad) (rad / M_PI * 180);

@interface MathUtils : NSObject

+(BOOL)floatEquals:(float) f0 with:(float) f1;

+(NSInteger)getAngleInCGContext:(NSInteger)angle;

+(CGFloat)distanceSquareFrom:(CGPoint) p0 To:(CGPoint) p1;

+(BOOL)isPoint:(CGPoint) p InCircleAt:(CGPoint) center WithRadius:(CGFloat) radius;

+(float)clip:(float)value InRange:(float) low and:(float)high;

+(float)linearInterpolationBetween:(float)start and:(float)end at:(float) percent;

+(float)cosInterpolationBetween:(float)start and:(float)end at:(float) percent;

@end
