//
//  NewsDetailViewController.m
//  ProjectAdam
//
//  Created by shizhan on 2017/2/25.
//  Copyright © 2017年 ___GUSTPLUS___. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "Marco.h"
#import "ViewUtils.h"
#import "HttpUtils.h"
#import "NewsContentCells.h"
#import "FullScreenImageView.h"

@interface NewsDetailViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleHeightContraint;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) FullScreenImageView *fullscreenImg;

@property (strong, nonatomic) NSMutableArray *data;
@end

@implementation NewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 200;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.allowsSelection = false;
    
    self.data = [[NSMutableArray alloc]init];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY= scrollView.contentOffset.y;
}

-(void)setNewsTitle:(NSString *)title
{
    self.titleLabel.text = title;
    CGSize size = [ViewUtils SizeOfText:title withFont:self.titleLabel.font withWidth:self.titleLabel.frame.size.width];
    self.titleHeightContraint.constant = size.height + 10;
    [self.view layoutIfNeeded];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setNewsTitle:self.title];
    
    [HttpUtils PostToUrl:@"http://192.168.1.108/adam/services/get_news.php" withEncoding:NSUTF8StringEncoding withParams:@{@"id" : self.id} withHeaders:nil selector:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        if(error)
        {
            NSLog(@"error occurs: %@", error);
        }
        else
        {
            if(data.length == 0)
            {
                NSLog(@"no resp");
            }
            else
            {
                NSLog(@"%@", [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
                @try {
                    id ret = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    [self.data addObjectsFromArray:ret];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
                } @catch (NSException *exception) {
                    NSLog(@"data parse error %@", exception.description);
                } @finally {
                    
                }
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id rowData = [self.data objectAtIndex:indexPath.row];
    for (NSString *key in rowData) {
        if([key isEqualToString:@"p"])
        {
            NewsContentTextCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"news_detail_text" forIndexPath:indexPath];
            NSString *content = rowData[key];
            if(!content || [content isMemberOfClass:[NSNull class]])
            {
                content = @"";
            }
            [cell setContent: content];
            return cell;
        }
        else if([key isEqualToString:@"img"])
        {
            NewsContentImageCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"news_detail_img" forIndexPath:indexPath];
            [cell setImgUrl:rowData[key] completeHander:^(UIImage *img) {
                [self performSelector:@selector(reloadCell:) withObject:indexPath afterDelay:0.1];
            }];
            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fullscreenImage:)];
            [cell.imgView addGestureRecognizer:recognizer];
            cell.imgView.userInteractionEnabled = YES;
            return cell;
        }
        else if([key isEqualToString:@"img_desc"])
        {
            NewsImageDescCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"news_img_desc" forIndexPath:indexPath];
                [cell setDesc: rowData[key]];
                return cell;
        }
    }
    NewsImageDescCell *defaultCell = [self.tableView dequeueReusableCellWithIdentifier:@"news_img_desc" forIndexPath:indexPath];
    return defaultCell;
}

-(void)reloadCell:(NSIndexPath *)indexPath
{
    NSArray *visIndices = self.tableView.indexPathsForVisibleRows;
    if([visIndices containsObject:indexPath])
    {
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    };
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(void)fullscreenImage:(UITapGestureRecognizer *)recognizer
{
    CGPoint loc = [recognizer locationInView:self.tableView];
    NSIndexPath *indexpath = [self.tableView indexPathForRowAtPoint:loc];
    NewsContentImageCell *selectedCell = [self.tableView cellForRowAtIndexPath:indexpath];
    UIImageView *imgView = selectedCell.imgView;
    
    self.fullscreenImg.backgroundColor = [UIColor blackColor];
    [self.fullscreenImg fullScreenImage:imgView];
}

-(FullScreenImageView *)fullscreenImg
{
    if(!_fullscreenImg)
    {
        _fullscreenImg = [[FullScreenImageView alloc]init];
        [self.self.navigationController.view addSubview:_fullscreenImg];
    }
    return _fullscreenImg;
}

@end
