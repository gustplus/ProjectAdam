//
//  NewsHubModel.h
//  ProjectAdam
//
//  Created by shizhan on 2017/2/11.
//  Copyright © 2017年 ___GUSTPLUS___. All rights reserved.
//

#import <UIKit/UIKit.h>


static NSString *const NewsTypeWeather = @"NewsTypeWeather";
static NSString *const NewsTypeText = @"NewsTypeText";
static NSString *const NewsTypePic = @"NewsTypePic";

@interface NewsData : NSObject

@property (strong, nonatomic) NSString *title;
@property (assign, nonatomic) NSString *type;
@property (strong, nonatomic) id content;
@property (assign, nonatomic) BOOL isInitialized;

-(instancetype)initWithType:(NSString *)type;

@end

@interface NewsHubModel : NSObject <UITableViewDataSource>

-(instancetype)init;

-(void)addNews:(NewsData *)news;
-(void)clearNews;

-(void)setWeather:(NewsData *)weather;

@end
