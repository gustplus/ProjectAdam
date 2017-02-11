//
//  ChatBar.h
//  ProjectAdam
//
//  Created by shizhan on 2017/2/8.
//  Copyright © 2017年 ___GUSTPLUS___. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChatViewDelegate <NSObject>

@required
-(void)endEditText:(NSString *)msg;

-(void)startListening;

@end

@interface ChatBarView : UIView

@property (strong, nonatomic) id<ChatViewDelegate> delegate;

-(instancetype)initWithCoder:(NSCoder *)aDecoder;

-(instancetype)initWithFrame:(CGRect)frame;

-(void)setText:(NSString *)text;
-(void)endEdit;
@end
