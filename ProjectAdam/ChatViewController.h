//
//  ChatViewController.h
//  ProjectAdam
//
//  Created by shizhan on 2017/2/2.
//  Copyright © 2017年 ___GUSTPLUS___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VoiceView.h"

@interface ChatViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (strong, nonatomic) VoiceView *voiceView;
@property (strong, nonatomic) UIView *maskView;

@property (weak, nonatomic) IBOutlet UIView *toolbar;
@property (weak, nonatomic) IBOutlet UIButton *voiceButton;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@end
