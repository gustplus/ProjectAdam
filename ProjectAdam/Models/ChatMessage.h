//
//  ChatMessage.h
//  ProjectAdam
//
//  Created by shizhan on 2017/2/2.
//  Copyright © 2017年 ___GUSTPLUS___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MsgType)
{
    kMsgTypeText,
    kMsgTypeImage,
    kMsgTypeVoice
};

@interface ChatMessage : NSObject

@property (assign, nonatomic) MsgType type;

@property (strong, nonatomic) NSString *senderName;

@property (strong, nonatomic) NSString *text;

-(CGSize) getMessageTextSizeWithWidth:(CGFloat)width;

@end
