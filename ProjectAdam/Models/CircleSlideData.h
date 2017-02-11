//
//  CircleSlideData.h
//  ProjectAdam
//
//  Created by shizhan on 2017/2/1.
//  Copyright © 2017年 ___GUSTPLUS___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GraphicUtils.h"

@protocol SliderDelegate <NSObject>

@required
-(void) valueChanged:(CGFloat) newvalue withTag:(NSInteger) tag;

@optional
-(void) valueChanging:(CGFloat) newvalue withTag:(NSInteger) tag;

@end

@interface CircleSlideData : NSObject

@property(assign, nonatomic) float min;
@property(assign, nonatomic) float interval;
@property(assign, nonatomic) float value;
@property(assign, nonatomic) NSInteger tag;

@property(strong, nonatomic)id<SliderDelegate> delegate;

-(instancetype)init;

-(instancetype)initWithMin:(float) min AndInterval:(float) interval;

-(void)setInterval:(float)interval;

-(void)setValue:(float)value;

-(void)setValueEnd:(float)value;

@end
