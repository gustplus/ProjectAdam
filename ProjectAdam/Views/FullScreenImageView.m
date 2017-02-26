//
//  FullScreenImageVIew.m
//  ProjectAdam
//
//  Created by shizhan on 2017/2/25.
//  Copyright © 2017年 ___GUSTPLUS___. All rights reserved.
//

#import "FullScreenImageVIew.h"
#import "ViewUtils.h"

@interface FullScreenImageView()
@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizer;
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
    }
    return self;
}

-(void)tap:(UITapGestureRecognizer *)tapRecognizer
{
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = self.originalFrame;
        self.imgView.frame = self.bounds;
    } completion:^(BOOL finished){
        self.hidden = YES;
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
    [UIView animateWithDuration:0.5 animations:^{
        CGRect dest = CGRectMake(0, (self.superview.bounds.size.height - imgHeight) * 0.5, imgWidth, imgHeight);
        self.imgView.frame = dest;
        
        self.frame = self.superview.bounds;
    }];
}

@end
