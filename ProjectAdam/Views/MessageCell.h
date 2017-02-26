//
//  MessageCellTableViewCell.h
//  ProjectAdam
//
//  Created by shizhan on 2017/2/2.
//  Copyright © 2017年 ___GUSTPLUS___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatMessage.h"
#import "Config.h"

@interface MessageCell : UITableViewCell

@property (strong, nonatomic, nonnull)BaseChatMessage *msg;

- (instancetype _Nonnull)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier;

-(void) setMsg:(BaseChatMessage * _Nonnull)msg;

@end
