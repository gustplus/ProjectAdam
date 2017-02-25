//
//  FullScreenImageVIew.m
//  ProjectAdam
//
//  Created by shizhan on 2017/2/25.
//  Copyright © 2017年 ___GUSTPLUS___. All rights reserved.
//

#import "FullScreenImageVIew.h"
#import "Masonry.h"

@interface FullScreenImageView()
@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizer;
@end

@implementation FullScreenImageView

-(instancetype) init
{
    self = [super initWithFrame:CGRectMake(0, 0, 0, 0)];
    if(self)
    {
        self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    }
    return self;
}

-(void)tap:(UITapGestureRecognizer *)tapRecognizer
{
    
}

-(void)FullScreenImage:(UIImageView *)view
{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
