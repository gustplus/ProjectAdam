//
//  NewsCell+Weather.h
//  ProjectAdam
//
//  Created by shizhan on 2017/2/19.
//  Copyright © 2017年 ___GUSTPLUS___. All rights reserved.
//
#import <UIKit/UIKit.h>

const static CGFloat kWeatherCellHeight = 250;

@interface WeatherCell : UIView

-(instancetype)initWithFrame:(CGRect)frame;

-(void)loadData;
@end
