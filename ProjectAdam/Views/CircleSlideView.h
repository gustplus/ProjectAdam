//
//  CircleSlideView.h
//  ProjectAdam
//
//  Created by shizhan on 2017/2/1.
//  Copyright © 2017年 ___GUSTPLUS___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphicUtils.h"

@class CircleSlideData;

typedef NS_ENUM(NSUInteger, SlideState)
{
    kStateNone,
    kStateUp,
    kStateDown,
    kStateReachBottom,
    kStateReachTop
};

@interface CircleSlideWrapper : CircleData

@property(strong, nonatomic)CircleSlideData *data;
@property(assign, nonatomic)SlideState state;
@property(assign, nonatomic)NSInteger preAngle;

-(void)setColorWithR:(float)red G:(float)green B:(float)blue;

-(BOOL) isPointIn:(CGPoint)point;
-(CGPoint)headPoint;
-(NSInteger)pointAngle:(CGPoint)point;

-(void)beginTouch:(CGPoint) point;
-(void)moveTouch:(CGPoint) point;
-(void)endTouch:(CGPoint) point;

-(NSInteger)getStartAngle;
-(NSInteger)getEndAngle;

@end


@interface CircleSlideView : UIView

@property(assign, nonatomic) Color highlightColor;
@property(assign, nonatomic) Color backColor;
@property(assign, nonatomic) NSUInteger slotPadding;
@property(assign, nonatomic) NSUInteger padding;
@property(assign, nonatomic) NSUInteger centerPadding;

-(instancetype)initWithCoder:(NSCoder *)aDecoder;
-(void)addSlider:(CircleSlideData *)data WithColor:(Color) color;

@end
