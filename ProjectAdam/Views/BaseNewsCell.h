//
//  NewsCell.h
//  ProjectAdam
//
//  Created by shizhan on 2017/2/11.
//  Copyright © 2017年 ___GUSTPLUS___. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewsData;

const static CGFloat kNewsCellHeight = 200;


@interface BaseNewsCell : UITableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

-(void)setNews:(NewsData *)data;

-(void)setupUI;
-(void)setupConstraints;

@end
