//
//  ChatMessage.m
//  ProjectAdam
//
//  Created by shizhan on 2017/2/2.
//  Copyright © 2017年 ___GUSTPLUS___. All rights reserved.
//

#import "ChatMessage.h"
#import "Marco.h"

@implementation ChatMessage

-(CGSize) getMessageTextSizeWithWidth:(CGFloat)width
{
    UIFont *textFont = [UIFont systemFontOfSize:20];
    NSDictionary *attrs = @{NSFontAttributeName: textFont};
    
    CGRect bound = [self.text boundingRectWithSize:CGSizeMake(width, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil];
    return bound.size;
}

@end
