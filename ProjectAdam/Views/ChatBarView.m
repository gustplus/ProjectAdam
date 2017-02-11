//
//  ChatBar.m
//  ProjectAdam
//
//  Created by shizhan on 2017/2/8.
//  Copyright © 2017年 ___GUSTPLUS___. All rights reserved.
//

#import "ChatBarView.h"

@interface ChatBarView()<UITextViewDelegate>
@property (strong, nonatomic) UIButton *voiceBtn;
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UIButton *addBtn;
@property (strong, nonatomic) NSLayoutConstraint *textViewHeightConstraint;
@end

@implementation ChatBarView

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self setupComponents];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self setupComponents];
        
        [self setupConstraints];
        
        [self setupActions];
    }
    return self;
}

-(void)setText:(NSString *)text
{
    self.textView.text = text;
    
    [self updateTextViewHeight];
}

-(void)setupComponents
{
    //voice button
    self.voiceBtn = [[UIButton alloc]initWithFrame:CGRectZero];
    [self.voiceBtn setImage:[UIImage imageNamed:@"voice_btn"] forState:UIControlStateNormal];
    [self.voiceBtn sizeToFit];
    [self addSubview:self.voiceBtn];
    
    //text view
    self.textView = [[UITextView alloc]initWithFrame:CGRectZero];
    self.textView.scrollEnabled = NO;
    self.textView.delegate = self;
    self.textView.font = [UIFont systemFontOfSize:18];
    self.textView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    self.textView.layer.borderWidth = 0.4;
    self.textView.layer.cornerRadius = 8;
    [self.textView sizeToFit];
    [self addSubview:self.textView];
    
    self.addBtn = [[UIButton alloc]initWithFrame:CGRectZero];
    [self.addBtn setImage:[UIImage imageNamed:@"add_normal"] forState:UIControlStateNormal];
    [self.addBtn setImage:[UIImage imageNamed:@"add_highlight"] forState:UIControlStateHighlighted];
    [self.addBtn sizeToFit];
    [self addSubview:self.addBtn];
}

-(void)setupConstraints
{
    self.voiceBtn.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *voiceBtnWdithConstraint = [NSLayoutConstraint constraintWithItem:self.voiceBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:self.voiceBtn.frame.size.width];
    [self addConstraint:voiceBtnWdithConstraint];
    
    NSLayoutConstraint *voiceBtnBottomConstraint = [NSLayoutConstraint constraintWithItem:self.voiceBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-15];
    [self addConstraint:voiceBtnBottomConstraint];
    
    NSLayoutConstraint *voiceBtnHeadConstraint = [NSLayoutConstraint constraintWithItem:self.voiceBtn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10];
    [self addConstraint:voiceBtnHeadConstraint];
    
    self.textView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *textViewLeftConstraint = [NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.voiceBtn attribute:NSLayoutAttributeRight multiplier:1.0 constant:10];
    [self addConstraint:textViewLeftConstraint];
    
    NSLayoutConstraint *textViewTopConstraint = [NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:10];
    [self addConstraint:textViewTopConstraint];
    
    NSLayoutConstraint *textViewBottomConstraint = [NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-10];
    [self addConstraint:textViewBottomConstraint];
    
    self.textViewHeightConstraint = [NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:37];
    [self addConstraint:self.textViewHeightConstraint];
    
    self.addBtn.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *addBtnWdithConstraint = [NSLayoutConstraint constraintWithItem:self.addBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:self.addBtn.frame.size.width];
    [self addConstraint:addBtnWdithConstraint];
    
    NSLayoutConstraint *addBtnLeftConstraint = [NSLayoutConstraint constraintWithItem:self.addBtn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.textView attribute:NSLayoutAttributeRight multiplier:1.0 constant:10];
    [self addConstraint:addBtnLeftConstraint];
    
    NSLayoutConstraint *addBtnBottomConstraint = [NSLayoutConstraint constraintWithItem:self.addBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-15];
    [self addConstraint:addBtnBottomConstraint];
    
    NSLayoutConstraint *addBtnRightConstraint = [NSLayoutConstraint constraintWithItem:self.addBtn attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-10];
    [self addConstraint:addBtnRightConstraint];
}

-(void)setupActions
{
    [self.voiceBtn addTarget:self action:@selector(voiceBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)voiceBtnClicked:(id)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(startListening)])
    {
        [self.delegate startListening];
    }
}

-(void)endEdit
{
    [self.textView resignFirstResponder];
}

-(void)updateTextViewHeight
{
    CGSize contentRect = [self.textView sizeThatFits: self.textView.frame.size];
    self.textViewHeightConstraint.constant = contentRect.height;
    
    [self.superview layoutIfNeeded];
}

-(void)textViewDidChange:(UITextView *)textView
{
    [self updateTextViewHeight];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        if(self.delegate && [self.delegate respondsToSelector:@selector(endEditText:)])
        {
            [self.delegate endEditText:textView.text];
        }
        
        textView.text = @"";
        [textView setAttributedText:nil];
        [self updateTextViewHeight];
        return NO;
    }
    return YES;
}

@end
