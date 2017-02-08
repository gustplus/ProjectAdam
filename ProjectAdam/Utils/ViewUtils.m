//
//  ViewUtils.m
//  ProjectAdam
//
//  Created by shizhan on 2017/2/7.
//  Copyright © 2017年 ___GUSTPLUS___. All rights reserved.
//

#import "ViewUtils.h"

@implementation ViewUtils

+(void)SetView:(UIView *)view height:(CGFloat)height
{
    CGRect frame = view.frame;
    frame.size.height = height;
    view.frame = frame;
}


+(void)SetView:(UIView *)view y:(CGFloat)y
{
    CGRect frame = view.frame;
    frame.origin.y = y;
    view.frame = frame;
}

@end
