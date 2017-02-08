//
//  MessageCellTableViewCell.m
//  ProjectAdam
//
//  Created by shizhan on 2017/2/2.
//  Copyright © 2017年 ___GUSTPLUS___. All rights reserved.
//

#import "MessageCell.h"
#import "Marco.h"

@implementation MessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)setMsg:(ChatMessage *)msg
{
    _msg = msg;
    switch (msg.type)
    {
        case kMsgTypeText:
            [self showTextMsg: msg];
            break;
            
        default:
            break;
    }
}

-(void)showTextMsg:(ChatMessage *)msg
{
    for (UIView *view in [self subviews])
    {
        [view removeFromSuperview];
    }
    
    CGFloat screenWidth = ScreenWidth;
    
    UIImageView *contextBack = [[UIImageView alloc] init];
    CGSize textSize = [msg getMessageTextSizeWithWidth:screenWidth - kTextMargin];
    
    UIImageView *userIcon = [[UIImageView alloc]init];
    UIImage *img = [UIImage imageNamed:@"user_icon"];
    userIcon.image = img;
    [userIcon sizeToFit];
    
    UIActivityIndicatorView *loadingIcon = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [loadingIcon startAnimating];
    loadingIcon.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    
    CGRect iconRect = userIcon.frame;
    if([msg.senderName isEqualToString: @"me"])
    {
        iconRect.origin.x = screenWidth - kCellMarginHorizontal - iconRect.size.width;
        iconRect.origin.y = kCellMarginVertical;
        
        contextBack.frame = CGRectMake(iconRect.origin.x - kCellMarginHorizontal - 2 * kIconTextPadding - textSize.width, kCellMarginVertical , textSize.width + 2 * kTextPadding, textSize.height + 2 * kTextPadding);
        contextBack.image = [[UIImage imageNamed:@"mychat"]stretchableImageWithLeftCapWidth:10 topCapHeight:25];
        
        loadingIcon.frame = CGRectMake(contextBack.frame.origin.x - kIconTextPadding - loadingIcon.frame.size.width, contextBack.frame.origin.y + textSize.height * 0.5, loadingIcon.frame.size.width, loadingIcon.frame.size.height);
    }
    else
    {
        iconRect.origin.x = kCellMarginHorizontal;
        iconRect.origin.y = kCellMarginVertical;
        
        contextBack.frame = CGRectMake(kCellMarginHorizontal + iconRect.size.width + kIconTextPadding, kCellMarginVertical , textSize.width + kTextPadding, textSize.height + kTextPadding);
        contextBack.image = [[UIImage imageNamed:@"otherchat"]stretchableImageWithLeftCapWidth:10 topCapHeight:25];
        
        loadingIcon.frame = CGRectMake(contextBack.frame.origin.x + contextBack.frame.size.width + kIconTextPadding + loadingIcon.frame.size.width, contextBack.frame.origin.y + textSize.height * 0.5, loadingIcon.frame.size.width, loadingIcon.frame.size.height);
    }
    
    userIcon.frame = iconRect;
    
    CGRect textRect = CGRectMake(kTextPadding, kTextPadding, textSize.width, textSize.height);
    UILabel *label = [[UILabel alloc]initWithFrame:textRect];
    label.text = msg.text;
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    
    [contextBack addSubview:label];
    
    [self addSubview: userIcon];
    [self addSubview:contextBack];
    [self addSubview:loadingIcon];
    
    self.backgroundColor = [UIColor lightGrayColor];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
