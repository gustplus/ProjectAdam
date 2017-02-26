//
//  NewsCell.m
//  ProjectAdam
//
//  Created by shizhan on 2017/2/11.
//  Copyright © 2017年 ___GUSTPLUS___. All rights reserved.
//

#import "BaseNewsCell.h"
#import "NewsHubModel.h"
#import "Masonry.h"
#import <SDWebImage/UIImageView+WebCache.h>

const static NSInteger kNewsCellMarginHorizontal = 10;
const static NSInteger kNewsCellMarginVertical = 15;
const static NSInteger kTitleHorizontalMargin = 20;
const static NSInteger kTitleTopMargin = 20;

@interface BaseNewsCell()

@property (strong, nonatomic) UIView *background;
@property (strong, nonatomic) UILabel *title;
//@property (strong, nonatomic) UIActivityIndicatorView *loadingView;

@end

@implementation BaseNewsCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
        [self setupConstraints];
    }
    return self;
}

-(void)setupUI
{
    self.backgroundColor = [UIColor clearColor];
    self.background = [[UIView alloc]initWithFrame:CGRectZero];
    self.background.backgroundColor = [UIColor whiteColor];
    self.background.layer.cornerRadius = 20;
    self.background.layer.masksToBounds = YES;
    self.background.clipsToBounds = YES;
    [self addSubview:self.background];
    
    self.title = [[UILabel alloc]initWithFrame:CGRectZero];
    self.title.font = [UIFont systemFontOfSize:14];
    self.title.numberOfLines = 2;
    self.title.textColor = [UIColor blackColor];
    self.title.textAlignment = UITextAlignmentCenter;
    [self.background addSubview:self.title];
    
    self.img = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.img.contentMode = UIViewContentModeScaleAspectFill;
    self.img.userInteractionEnabled = YES;
    [self.background addSubview:self.img];
}

-(void)setupConstraints
{
    [self.background mas_makeConstraints:^(MASConstraintMaker *maker)
    {
        maker.left.equalTo(self.mas_left).with.offset(kNewsCellMarginHorizontal);
        maker.right.equalTo(self.mas_right).with.offset(-kNewsCellMarginHorizontal);
        maker.top.equalTo(self.mas_top).with.offset(kNewsCellMarginVertical);
        maker.bottom.equalTo(self.mas_bottom).with.offset(-kNewsCellMarginVertical);
    }];
    [self.title mas_makeConstraints:^(MASConstraintMaker *maker)
     {
         maker.left.equalTo(self.background.mas_left).with.offset(kTitleHorizontalMargin);
         maker.right.equalTo(self.background.mas_right).with.offset(-kTitleHorizontalMargin);
         maker.top.equalTo(self.background.mas_top).with.offset(kTitleTopMargin);
         maker.height.equalTo(@40).priorityLow();
     }];
    [self.img mas_makeConstraints:^(MASConstraintMaker *maker)
     {
         maker.centerX.equalTo(self.background.mas_centerX).with.offset(0);
         maker.top.equalTo(self.title.mas_bottom).with.offset(15);
         maker.width.equalTo(@165).priorityHigh();
         maker.height.equalTo(@100).priorityHigh();
    }];
}

-(void)setNews:(NewsData *)data
{
    self.title.text = data.title;
    if(data.content)
    {
        NSString *imgUrl = data.content[@"img_url"];
        [self.img sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"default_pic.jpg"] ];
    }
}

@end

