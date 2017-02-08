//
//  MessageCellTableViewCell.h
//  ProjectAdam
//
//  Created by shizhan on 2017/2/2.
//  Copyright © 2017年 ___GUSTPLUS___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatMessage.h"

const static NSInteger kTextMargin = 200;

const static NSInteger kCellMarginHorizontal = 20;
const static NSInteger kCellMarginVertical = 30;

const static NSInteger kIconTextPadding = 10;

const static NSInteger kTextPadding = 10;

@interface MessageCell : UITableViewCell

@property (strong, nonatomic, nonnull)ChatMessage *msg;

- (instancetype _Nonnull)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier;

-(void) setMsg:(ChatMessage * _Nonnull)msg;

@end
