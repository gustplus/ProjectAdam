//
//  ChatViewController.m
//  ProjectAdam
//
//  Created by shizhan on 2017/2/9.
//  Copyright © 2017年 ___GUSTPLUS___. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatBarView.h"
#import "ChatViewModel.h"
#import "SpeechRecognizer.h"
#import "Marco.h"
#import "VoiceView.h"
#import "MessageCell.h"

const static int kVoiceViewWidth = 200;
const static int kVoiceViewHeight = 170;

@interface ChatViewController () <UITableViewDelegate, ChatViewDelegate, SpeechDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) ChatBarView *toolbar;
@property (strong, nonatomic) VoiceView *voiceView;
@property (strong, nonatomic) UIView *maskView;

@property (strong, nonatomic) ChatViewModel *dataModel;
@property (assign, nonatomic) BOOL showingKeyboard;
@property (strong, nonatomic) SpeechRecognizer *recognizer;
@property (strong, nonatomic) NSLayoutConstraint *chatbarBottomConstraint;
@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Adam";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem *settingBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed: @"setting_btn"] style:UIBarButtonItemStylePlain target:self action:@selector(settingAction:)];
    self.navigationItem.rightBarButtonItem = settingBtn;
    
    self.showingKeyboard = NO;
    
    self.dataModel = [[ChatViewModel alloc] init];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self.dataModel;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.backgroundColor = [UIColor lightGrayColor];
    [self.tableView registerClass:[MessageCell class] forCellReuseIdentifier:kChatMessageIdentifier];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [self.tableView addGestureRecognizer:tapRecognizer];
    [self.view addSubview:self.tableView];
    
    self.toolbar = [[ChatBarView alloc] initWithFrame:CGRectZero];
    self.toolbar.delegate = self;
    [self.view addSubview:self.toolbar];
    
    self.recognizer = [SpeechRecognizer sharedInstance];
    
    [self setupConstraints];
    [self addKeyoardStateListener];
    
    TextChatMessage *welcomeMsg = [[TextChatMessage alloc]init];
    welcomeMsg.senderName = @"adam";
    welcomeMsg.owner = kMsgOwnerOther;
    welcomeMsg.text = @"hello!";
    [self.dataModel getMessage:welcomeMsg];
}

-(void)settingAction:(id) sender
{
    UIViewController *dest = [self.storyboard instantiateViewControllerWithIdentifier:@"settingController"];
    dest.title = @"Settings";
    dest.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    [self.navigationController pushViewController:dest animated:YES];
}

-(void)tap:(UITapGestureRecognizer *)recognizer
{
    [self.toolbar endEdit];
}

-(void)setupConstraints
{
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.toolbar.translatesAutoresizingMaskIntoConstraints = NO;
    //tableview
    NSLayoutConstraint *tableViewTopConstraint = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    [self.view addConstraint:tableViewTopConstraint];
    
    NSLayoutConstraint *tableViewLeftConstraint = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    [self.view addConstraint:tableViewLeftConstraint];
    
    NSLayoutConstraint *tableViewRightConstraint = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    [self.view addConstraint:tableViewRightConstraint];
    
    NSLayoutConstraint *tableViewBottomConstraint = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.toolbar attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    [self.view addConstraint:tableViewBottomConstraint];
    
    //chatbar
    self.chatbarBottomConstraint = [NSLayoutConstraint constraintWithItem:self.toolbar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [self.view addConstraint:self.chatbarBottomConstraint];
    
    NSLayoutConstraint *toolbarLeftConstraint = [NSLayoutConstraint constraintWithItem:self.toolbar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    [self.view addConstraint:toolbarLeftConstraint];
    
    NSLayoutConstraint *toolbarRightConstraint = [NSLayoutConstraint constraintWithItem:self.toolbar attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    [self.view addConstraint:toolbarRightConstraint];
}

-(void)addKeyoardStateListener
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

-(void)tableViewScrollToBottom
{
    NSUInteger count = [self.dataModel tableView:self.tableView numberOfRowsInSection:0];
    if(count > 0)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:count - 1 inSection:0];
        [self.tableView scrollToRowAtIndexPath: indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.dataModel heightOfIndexPath:indexPath];
}

#pragma mark - Orientation

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(void)keyboardWillShow:(NSNotification *)notification
{
    self.showingKeyboard = YES;
    
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardY = keyboardFrame.origin.y;
    
    self.chatbarBottomConstraint.constant = keyboardY - ScreenHeight;
    [self.view layoutIfNeeded];
    
    [self tableViewScrollToBottom];
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    self.chatbarBottomConstraint.constant = 0;
    [self.view layoutIfNeeded];
    self.showingKeyboard = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onVolumeChanged:(float)volume
{
    static int idx = 0;
    if((idx++) % 20)
    {
        [self.voiceView setVolume:volume + 1];
    }
}

-(void)onStart
{
    if(!self.voiceView)
    {
        self.maskView = [[UIView alloc] initWithFrame:self.view.frame];
        [self.view addSubview:self.maskView];
        
        CGFloat screenWidth = ScreenWidth;
        CGFloat screenHeight = ScreenHeight - TOPBAR_HEIGHT;
        self.voiceView = [[VoiceView alloc]initWithFrame:CGRectMake((screenWidth - kVoiceViewWidth) * 0.5, (screenHeight - kVoiceViewHeight) * 0.5, kVoiceViewWidth, kVoiceViewHeight)];
        
        self.voiceView.layer.cornerRadius = 10;
        self.voiceView.layer.masksToBounds = YES;
        self.voiceView.style = VoiceViewStyleBottom;
        self.voiceView.slotCount = 20;
        self.voiceView.slotPadding = 2;
        [self.view addSubview:self.voiceView];
    }
    self.maskView.hidden = NO;
    self.voiceView.hidden = NO;
}

-(void)onEnd
{
    self.voiceView.hidden = YES;
    self.maskView.hidden = YES;
}

-(void)onResult:(NSArray *)s
{
    NSString *ret = [s componentsJoinedByString:@""];
    [self sendTextMessage:ret];
}

-(void)onError
{
    TextChatMessage *errMsg = [[TextChatMessage alloc]init];
    errMsg.senderName = @"adam";
    errMsg.owner = kMsgOwnerOther;
    errMsg.text = @"我听不懂你在说什么";
    [self.dataModel getMessage:errMsg];
}

-(void)startListening
{
    [self.recognizer startListening];
    self.recognizer.delegate = self;
}

-(void)sendTextMessage:(NSString *)msg
{
    if(msg.length > 0)
    {
        [self.dataModel sendTextMessage:msg];
        [self.tableView reloadData];
        [self tableViewScrollToBottom];
    }
}

-(void)endEditText:(NSString *)msg
{
    [self sendTextMessage:msg];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
