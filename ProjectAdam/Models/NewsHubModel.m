//
//  NewsHubModel.m
//  ProjectAdam
//
//  Created by shizhan on 2017/2/11.
//  Copyright © 2017年 ___GUSTPLUS___. All rights reserved.
//

#import "NewsHubModel.h"

#import "BaseNewsCell.h"

@implementation NewsData

-(instancetype)initWithType:(NSString *)type
{
    self = [super init];
    if(self)
    {
        _type = type;
        _isInitialized = NO;
        _content = nil;
    }
    return self;
}

-(void)setContent:(id)content
{
    _content = content;
    self.isInitialized = YES;
}

@end


@interface NewsHubModel()

@property (strong, nonatomic) NSMutableArray *news;

@end

@implementation NewsHubModel

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        self.news = [[NSMutableArray alloc]initWithCapacity:10];
        
    }
    return self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return self.news.count;
    return self.news.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsData *data = self.news[indexPath.row];
    BaseNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:data.type forIndexPath:indexPath];
    [cell setNews:data];
    return cell;
}

-(void)addNews:(NewsData *)news
{
    [self.news addObject:news];
}

-(void)clearNews
{
    [self.news removeAllObjects];
}

-(void)setWeather:(NewsData *)weather
{
    if([weather.type isEqualToString:NewsTypeWeather])
    {
        NewsData *first = [self.news objectAtIndex:0];
        if(first && [first.type isEqualToString:NewsTypeWeather])
        {
            first.title = weather.title;
            first.content = weather.content;
        }
        else
        {
            [self.news insertObject:weather atIndex:0];
        }
    }
}

@end
