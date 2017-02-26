//
//  NewsContentImageCell.h
//  ProjectAdam
//
//  Created by shizhan on 2017/2/26.
//  Copyright © 2017年 ___GUSTPLUS___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsContentImageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

-(void)setImgUrl:(NSString *)url completeHander:(void(^)(UIImage *image))handler;
@end

@interface NewsImageDescCell : UITableViewCell
-(void)setDesc:(NSString *)desc;
@end

@interface NewsContentTextCell : UITableViewCell
-(void)setContent:(NSString *)content;
@end
