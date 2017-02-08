//
//  CircleSlideView.h
//  ProjectAdam
//
//  Created by shizhan on 2017/2/1.
//  Copyright © 2017年 ___GUSTPLUS___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphicUtils.h"
#import "CircleSlideData.h"

@interface CircleSlideView : UIView

@property(assign, nonatomic) Color highlightColor;
@property(assign, nonatomic) Color backColor;
@property(assign, nonatomic) NSUInteger slotPadding;
@property(assign, nonatomic) NSUInteger padding;
@property(assign, nonatomic) NSUInteger centerPadding;

-(instancetype)initWithCoder:(NSCoder *)aDecoder;
-(void)addSlider:(CircleSlideData *)data WithColor:(Color) color;

@end
