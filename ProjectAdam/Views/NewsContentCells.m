//
//  NewsContentImageCell.m
//  ProjectAdam
//
//  Created by shizhan on 2017/2/26.
//  Copyright © 2017年 ___GUSTPLUS___. All rights reserved.
//

#import "NewsContentCells.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ViewUtils.h"

@interface NewsContentImageCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;
@end

@implementation NewsContentImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setImgUrl:(NSString *)url completeHander:(void(^)(UIImage *image))handler
{
    SDWebImageManager *mamager = SDWebImageManager.sharedManager;
    NSString *key = [mamager cacheKeyForURL:[NSURL URLWithString:url]];
    UIImage *img = [mamager.imageCache imageFromMemoryCacheForKey:key];
    if(img)
    {
        self.imgView.image = img;
        CGFloat width = self.imgView.frame.size.width;
        CGFloat height = width / img.size.width * img.size.height;
        self.heightConstraint.constant = height;
        [self layoutIfNeeded];
    }
    else
    {
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"default_pic.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            handler(image);
        }];
    }
}

@end


@interface NewsImageDescCell()
@property (weak, nonatomic) IBOutlet UILabel *descText;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightContraint;
@end

@implementation NewsImageDescCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setDesc:(NSString *)desc
{
    self.descText.text  = desc;
    CGFloat width = self.descText.frame.size.width;
    CGSize size = [ViewUtils SizeOfText:desc withFont:self.descText.font withWidth: width];
    self.heightContraint.constant = size.height + 15;
    [self.contentView layoutIfNeeded];
}

@end


@interface NewsContentTextCell()
@property (weak, nonatomic) IBOutlet UILabel *contentText;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightContraint;
@end

@implementation NewsContentTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setContent:(NSString *)content
{
    self.contentText.text = content;
    CGSize size = [ViewUtils SizeOfText:content withFont:self.contentText.font withWidth:self.contentText.frame.size.width];
    self.heightContraint.constant = size.height + 15;
    [self.contentView layoutIfNeeded];
}

@end
