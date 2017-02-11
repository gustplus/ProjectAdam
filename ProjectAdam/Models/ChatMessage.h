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

typedef NS_ENUM(NSInteger, MsgState)
{
    kMsgStateUnknown,
    kMsgStateSending,
    kMsgStateReceiving,
    kMsgStateSuc,
    kMsgStateFail
    
};

typedef NS_ENUM(NSInteger, MsgOwner)
{
    kMsgOwnerSelf,
    kMsgOwnerOther
};;

@interface BaseChatMessage : NSObject

@property (assign, nonatomic, readonly) MsgType type;
@property (assign, nonatomic) MsgState state;
@property (assign, nonatomic) MsgOwner owner;

@property (strong, nonatomic) NSString *senderName;
@property (strong, nonatomic) NSString *avatarUrl;  //头像url

-(instancetype)initWithType:(MsgType) type;

-(CGFloat)heightOfCell;

@end

@interface TextChatMessage : BaseChatMessage

@property (strong, nonatomic) NSString *text;

-(instancetype)init;

-(CGFloat)heightOfCell;

-(CGSize) getMessageTextSizeWithWidth:(CGFloat)width;

@end
