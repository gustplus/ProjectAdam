//
//  ChatMessage.m
//  ProjectAdam
//
//  Created by shizhan on 2017/2/2.
//  Copyright © 2017年 ___GUSTPLUS___. All rights reserved.
//

#import "ChatMessage.h"
#import "Marco.h"
#import "Config.h"

@implementation BaseChatMessage

-(instancetype)initWithType:(MsgType) type
{
    self = [super init];
    if(self)
    {
        _type = type;
    }
    return self;
}

-(CGFloat)heightOfCell
{
    return 0;
}

@end

@implementation TextChatMessage

-(instancetype)init
{
    self = [super initWithType:kMsgTypeText];
    
    return self;
}

-(CGFloat)heightOfCell
{
    return [self getMessageTextSizeWithWidth: ScreenWidth - kTextMargin].height + 2 * kCellMarginVertical;
}

-(CGSize) getMessageTextSizeWithWidth:(CGFloat)width
{
    UIFont *textFont = [UIFont systemFontOfSize:20];
    NSDictionary *attrs = @{NSFontAttributeName: textFont};
    
    CGRect bound = [self.text boundingRectWithSize:CGSizeMake(width, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil];
    return bound.size;
}

@end
