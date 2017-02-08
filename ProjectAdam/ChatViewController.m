//
//  ChatViewController.m
//  ProjectAdam
//
//  Created by shizhan on 2017/2/2.
//  Copyright © 2017年 ___GUSTPLUS___. All rights reserved.
//

#import "ChatViewController.h"
#import "MessageCell.h"
#import "ChatMessage.h"
#import "Marco.h"
#import "SpeechRecognizer.h"
#import "ViewUtils.h"

const static int kVoiceViewWidth = 200;
const static int kVoiceViewHeight = 170;

@interface ChatViewController ()<SpeechDelegate, UITextViewDelegate>

@property(strong, nonatomic)NSMutableArray *msgs;
@property (strong, nonatomic) SpeechRecognizer *recognizer;
@property (assign, nonatomic) CGFloat originalToolbarHeight;
@property (assign, nonatomic) CGFloat originalTextFieldHeight;
@property (assign, nonatomic) BOOL keyboardIsShowing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolbarBottomConstraint;
@property (assign, nonatomic) CGFloat keyboardY;
@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.keyboardIsShowing = NO;
    self.msgs = [NSMutableArray array];
    self.recognizer = [SpeechRecognizer sharedInstance];
    self.keyboardY = ScreenHeight - TOPBAR_HEIGHT;
    
    [self.tableview registerClass:[MessageCell class] forCellReuseIdentifier:@"msg"];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.backgroundColor = [UIColor lightGrayColor];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [self.tableview addGestureRecognizer:tapRecognizer];
    
    self.textView.delegate = self;
    
    self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textView.layer.borderWidth = 1;
    self.textView.layer.cornerRadius = 10;
    self.textView.layer.masksToBounds = YES;
    
    self.voiceButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.voiceButton.layer.borderWidth = 1;
    self.voiceButton.layer.cornerRadius = 6;
    self.voiceButton.layer.masksToBounds = YES;
    
    self.sendButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.sendButton.layer.borderWidth = 1;
    self.sendButton.layer.cornerRadius = 6;
    self.sendButton.layer.masksToBounds = YES;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.originalToolbarHeight = self.toolbar.frame.size.height;
    self.originalTextFieldHeight = self.textView.frame.size.height;
    NSLog(@"y = %f", self.toolbar.frame.origin.y);
}

-(void)tap:(UITapGestureRecognizer *)recognizer
{
    [self.textView resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.msgs count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.msgs[indexPath.row] getMessageTextSizeWithWidth: ScreenWidth - kTextMargin].height + 2 * kCellMarginVertical;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageCell *cell = [self.tableview dequeueReusableCellWithIdentifier:@"msg" forIndexPath:indexPath];
    cell.msg = self.msgs[indexPath.row];
    return cell;
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
    self.textView.text = [NSString stringWithFormat:@"%@\n%@", self.textView.text, ret ];
}

- (IBAction)startListening:(id)sender
{
    [self.recognizer startListening];
    self.recognizer.delegate = self;
}

- (IBAction)sendMessageAction:(id)sender
{
    NSString *msg = self.textView.text;
    if(msg.length > 0)
    {
        [self sendTextMessage:msg];
        self.textView.text = @"";
        [ViewUtils SetView:self.textView height:self.originalTextFieldHeight];
        [self updateTextViewFrame];
    }
}

-(void)pushMessage:(ChatMessage *)msg
{
    [self.msgs addObject:msg];
    [self.tableview reloadData];
    [self tableViewScrollToBottom];
}

-(void)tableViewScrollToBottom
{
    NSUInteger count = self.msgs.count;
    if(count > 0)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:count - 1 inSection:0];
        [self.tableview scrollToRowAtIndexPath: indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

-(void)sendTextMessage:(NSString *)text
{
    ChatMessage *msg = [[ChatMessage alloc]init];
    msg.type = kMsgTypeText;
    msg.text = text;
    msg.senderName = @"me";
    [self pushMessage:msg];
}

-(void)updateTextViewFrame
{
    CGSize sizeThatShouldFitTheContent = [self.textView sizeThatFits:self.textView.frame.size];
    self.textViewHeightConstraint.constant = sizeThatShouldFitTheContent.height;
    [self.view layoutIfNeeded];
}

#pragma mark - Orientation

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

 #pragma mark - TextFieldDelegate

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    
}

-(void)textViewDidChange:(UITextView *)textView
{
    [self updateTextViewFrame];
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    
}

-(void)keyboardWillShow:(NSNotification *)notification
{
    self.keyboardIsShowing = YES;
    
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardY = keyboardFrame.origin.y;
    
    self.toolbarBottomConstraint.constant = ScreenHeight - keyboardY;
    [self.view layoutIfNeeded];
        
    [self tableViewScrollToBottom];
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    self.toolbarBottomConstraint.constant = 0;
    [self.view layoutIfNeeded];
    self.keyboardIsShowing = NO;
}

@end
