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

@class BaseNewsCell;

@interface NewsData : NSObject

@property (strong, nonatomic) NSString *title;
@property (assign, nonatomic) NSString *type;
@property (strong, nonatomic) id content;
@property (assign, nonatomic) BOOL isInitialized;

-(instancetype)initWithType:(NSString *)type;

@end

@interface NewsHubModel : NSObject

-(instancetype)init;

-(NewsData *)dataAt:(NSIndexPath *) indexPath;

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;

-(BaseNewsCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

-(void)addNews:(NewsData *)news;
-(void)clearNews;

@end
