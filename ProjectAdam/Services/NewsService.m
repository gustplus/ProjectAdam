//
//  NewsService.m
//  ProjectAdam
//
//  Created by shizhan on 2017/2/24.
//  Copyright © 2017年 ___GUSTPLUS___. All rights reserved.
//

#import "NewsService.h"
#import "HttpUtils.h"

@implementation NewsService

+(void)GetNewsWithPage:(NSInteger) page callback:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler
{
    [HttpUtils PostToUrl:@"http://192.168.1.108/adam/services/news_list.php" withEncoding:NSUTF8StringEncoding withParams:@{@"page":@(page)} withHeaders:nil selector:completionHandler];
}
@end

