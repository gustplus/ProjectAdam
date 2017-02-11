//
//  ChatViewModel.h
//  ProjectAdam
//
//  Created by shizhan on 2017/2/8.
//  Copyright © 2017年 ___GUSTPLUS___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ChatMessage.h"

static NSString *const kChatMessageIdentifier = @"ChatMessageIfentifier";

@interface ChatViewModel : NSObject <UITableViewDataSource>

-(instancetype)init;

-(void)sendTextMessage:(NSString *)text;

-(void)getMessage:(BaseChatMessage *)msg;

-(CGFloat)heightOfIndexPath:(NSIndexPath *) indexPath;

@end
