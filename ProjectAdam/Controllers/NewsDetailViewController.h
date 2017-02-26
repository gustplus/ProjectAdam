//
//  NewsDetailViewController.h
//  ProjectAdam
//
//  Created by shizhan on 2017/2/25.
//  Copyright © 2017年 ___GUSTPLUS___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsDetailViewController : UIViewController
@property (strong, nonatomic) NSString *id;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

-(void)setNewsTitle:(NSString *)title;

@end
