//
//  FullScreenImageVIew.m
//  ProjectAdam
//
//  Created by shizhan on 2017/2/25.
//  Copyright © 2017年 ___GUSTPLUS___. All rights reserved.
//

#import "FullScreenImageVIew.h"
#import "ViewUtils.h"
#import "Marco.h" 

@interface FullScreenImageView()
@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizer;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imgView;
@property (assign, nonatomic) CGRect originalFrame;
@end

@implementation FullScreenImageView

-(instancetype) init
{
    self = [super initWithFrame:CGRectMake(0, 0, 0, 0)];
    if(self)
    {
        self.userInteractionEnabled = YES;
        self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:self.tapRecognizer];
        
        self.imgView = [[UIImageView alloc]initWithFrame:self.frame];
        [self addSubview:self.imgView];
        
        self.scrollView = [[UIScrollView alloc]initWithFrame:self.frame];
        [self addSubview:self.scrollView];
        self.scrollView.bounces = YES;
        self.scrollView.hidden =YES;
    }
    return self;
}

-(void)tap:(UITapGestureRecognizer *)tapRecognizer
{
    [self.imgView removeFromSuperview];
    CGRect frame = self.imgView.frame;
    frame.origin.y = self.scrollView.frame.origin.y;
    self.imgView.frame = frame;
    [self addSubview:self.imgView];
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = self.originalFrame;
        self.imgView.frame = self.bounds;
    } completion:^(BOOL finished){
        self.hidden = YES;
        self.scrollView.hidden = YES;
    }];
}

-(void)fullScreenImage:(UIImageView *)imgView
{
    self.hidden = NO;
    
    self.imgView.image = imgView.image;
    self.originalFrame = [imgView convertRect:imgView.bounds toView:self.superview];
    self.frame = self.originalFrame;
    self.imgView.frame = self.bounds;
    self.imgView.contentMode = imgView.contentMode;
    CGFloat imgWidth = self.superview.frame.size.width;
    CGFloat imgHeight = imgWidth / self.originalFrame.size.width * self.originalFrame.size.height;
    CGFloat y = (self.superview.bounds.size.height - imgHeight) * 0.5;
    [UIView animateWithDuration:0.5 animations:^{
        CGRect dest = CGRectMake(0, y < 0 ? 0 : y, imgWidth, imgHeight);
        self.imgView.frame = dest;
        
        self.frame = self.superview.bounds;
    } completion:^(BOOL finished) {
        self.scrollView.hidden = NO;
        if(imgHeight > ScreenHeight)
        {
            self.scrollView.frame = self.superview.bounds;
        }
        else
        {
            self.scrollView.frame = self.imgView.frame;
        }
        self.imgView.frame = self.imgView.bounds;
        [self.imgView removeFromSuperview];
        [self.scrollView addSubview:self.imgView];
    }];
}

@end
