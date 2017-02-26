//
//  NewsHubViewController.m
//  ProjectAdam
//
//  Created by shizhan on 2017/2/11.
//  Copyright © 2017年 ___GUSTPLUS___. All rights reserved.
//

#import "NewsHubViewController.h"
#import "BaseNewsCell.h"
#import "WeatherCell.h"
#import "NewsHubModel.h"
#import "Marco.h"
#import "NewsHubPresentationController.h"
#import "NewsDetailViewController.h"
#import "WeatherService.h"
#import "NewsService.h"
#import "Masonry.h"
#import "MathUtils.h"
#import "RefreshHeaderView.h"
#import "ViewUtils.h"
#import "FullScreenImageView.h"

@interface NewsHubViewController () <UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIToolbar *toolbar;
@property (strong, nonatomic) UIBarButtonItem *settingBtn;

@property (strong, nonatomic) FullScreenImageView *fullscreenImg;

@property (strong, nonatomic) NewsHubModel *dataSource;

@property (assign, nonatomic) BOOL isInitialized;

@property (strong, nonatomic) RefreshHeaderView *refreshView;


@end

@implementation NewsHubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self setupContraints];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.tableView registerClass:[BaseNewsCell class] forCellReuseIdentifier:NewsTypeText];
    
    self.isInitialized = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    if(self.isInitialized)
    {
        return;
    }
    [self loadNews];
    self.isInitialized = YES;
}

-(void)loadNews
{
    [NewsService GetNewsWithPage:0 callback:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        if (error)
        {
            NSLog(@"error %@", error.localizedDescription);
        }
        else
        {
            if(data.length > 0)
            {
                @try
                {
                    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
                    for (NSDictionary *obj in json)
                    {
                        NewsData *news = [[NewsData alloc]initWithType:NewsTypeText];
                        news.title = obj[@"title"];
                        news.content = obj;
                        [self.dataSource addNews:news];
                    }
                }
                @catch (NSException *exception)
                {
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)setupUI
{
    UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurbackgroundView = [[UIVisualEffectView alloc]initWithFrame:self.view.frame];
    blurbackgroundView.effect = blurEffect;
    self.view = blurbackgroundView;
    
    self.dataSource = [[NewsHubModel alloc]init];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    WeatherCell *weatherCell = [[WeatherCell alloc]initWithFrame:CGRectMake(0, 0, 0, kWeatherCellHeight)];
    self.tableView.tableHeaderView = weatherCell;
    self.tableView.rowHeight = 230;
    
    [self.view addSubview:self.tableView];
    
    self.toolbar = [[UIToolbar alloc]initWithFrame:CGRectZero];
    self.toolbar.barStyle = UIBarStyleBlackOpaque;
    [self.view addSubview:self.toolbar];
    
    self.settingBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(goSetting:)];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [self.toolbar setItems:@[flexSpace, self.settingBtn]];
    
    //self.refreshView = [[NSBundle mainBundle] loadNibNamed:@"RefreshHeaderView" owner:nil options:nil].lastObject;
    //self.refreshView.frame = CGRectMake(0, -100, ScreenWidth, 100);
    //[self.refreshView sizeToFit];
    //[self.tableView addSubview:self.refreshView];
}

-(void)setupContraints
{
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.toolbar.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *tableViewTopConstraint = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeTop multiplier:1.0 constant:TOPBAR_HEIGHT];
    [self.view addConstraint:tableViewTopConstraint];
    
    NSLayoutConstraint *tableViewLeftConstraint = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    [self.view addConstraint:tableViewLeftConstraint];
    
    NSLayoutConstraint *tableViewRightConstraint = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    [self.view addConstraint:tableViewRightConstraint];
    
    //toolbar
    NSLayoutConstraint *toolbarTopConstraint = [NSLayoutConstraint constraintWithItem:self.toolbar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.tableView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [self.view addConstraint:toolbarTopConstraint];
    
    NSLayoutConstraint *toolbarLeftConstraint = [NSLayoutConstraint constraintWithItem:self.toolbar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    [self.view addConstraint:toolbarLeftConstraint];
    
    NSLayoutConstraint *toolbarRightConstraint = [NSLayoutConstraint constraintWithItem:self.toolbar attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    [self.view addConstraint:toolbarRightConstraint];
    
    NSLayoutConstraint *toolbarBottomConstraint = [NSLayoutConstraint constraintWithItem:self.toolbar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [self.view addConstraint:toolbarBottomConstraint];
    
    NSLayoutConstraint *toolbarHeightConstraint = [NSLayoutConstraint constraintWithItem:self.toolbar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:40];
    [self.view addConstraint:toolbarHeightConstraint];
}

-(void)goSetting:(id)sender
{
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.y;
    [ViewUtils SetView:self.refreshView y:-(100 + offset)];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource tableView:tableView numberOfRowsInSection:section];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataSource numberOfSectionsInTableView:tableView];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseNewsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"newscell"];
    if(!cell)
    {
        cell = [[BaseNewsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"newscell"];
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fullscreenImage:)];
        [cell.img addGestureRecognizer:recognizer];
    }
    [cell setNews: [self.dataSource dataAt: indexPath]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsData *data = [self.dataSource dataAt:indexPath];
    if(data && data.content)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        NewsDetailViewController *dest = [storyboard instantiateViewControllerWithIdentifier:@"news_detail"];
        dest.id = data.content[@"id"];
        dest.title = data.title;
        [self.navigationController pushViewController:dest animated:YES];
//        [self presentViewController:dest animated:YES completion:^(){
//            [dest setNewsTitle:data.title];
//        }];
    }
}

-(void)fullscreenImage:(UITapGestureRecognizer *)recognizer
{
    CGPoint loc = [recognizer locationInView:self.tableView];
    NSIndexPath *indexpath = [self.tableView indexPathForRowAtPoint:loc];
    BaseNewsCell *selectedCell = [self.tableView cellForRowAtIndexPath:indexpath];
    UIImageView *imgView = selectedCell.img;
    
    self.fullscreenImg.backgroundColor = [UIColor blackColor];
    [self.fullscreenImg fullScreenImage:imgView];
}

-(FullScreenImageView *)fullscreenImg
{
    if(!_fullscreenImg)
    {
        _fullscreenImg = [[FullScreenImageView alloc]init];
        [self.navigationController.view addSubview:_fullscreenImg];
    }
    return _fullscreenImg;
}

@end
