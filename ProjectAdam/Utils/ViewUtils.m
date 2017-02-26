//
//  ViewUtils.m
//  ProjectAdam
//
//  Created by shizhan on 2017/2/7.
//  Copyright © 2017年 ___GUSTPLUS___. All rights reserved.
//

#import "ViewUtils.h"

@implementation ViewUtils

+(void)SetView:(UIView *)view width:(CGFloat) width height:(CGFloat)height
{
    CGRect frame = view.frame;
    frame.size.width = width;
    frame.size.height = height;
    view.frame = frame;
}

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

+(void)viewInfo:(UIView *)view
{
    NSLog(@"bounds %f %f %f %f", view.bounds.origin.x, view.bounds.origin.y, view.bounds.size.width, view.bounds.size.height);
    NSLog(@"frame %f %f %f %f", view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
}

+(CGSize) SizeOfText:(NSString *)text withFont:(UIFont *)font withWidth:(CGFloat) width
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    CGRect frame = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil];
    return frame.size;
}

@end
