//
//  ViewUtils.h
//  ProjectAdam
//
//  Created by shizhan on 2017/2/7.
//  Copyright © 2017年 ___GUSTPLUS___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ViewUtils : NSObject

+(void)SetView:(UIView *)view width:(CGFloat) width height:(CGFloat)height;

+(void)SetView:(UIView *)view height:(CGFloat)height;

+(void)SetView:(UIView *)view y:(CGFloat)y;

+(void)viewInfo:(UIView *)view;

+(CGSize) SizeOfText:(NSString *)text withFont:(UIFont *)font withWidth:(CGFloat) width;

@end
