//
//  NewsService.h
//  ProjectAdam
//
//  Created by shizhan on 2017/2/24.
//  Copyright © 2017年 ___GUSTPLUS___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsService : NSObject

+(void)GetNewsWithPage:(NSInteger) page callback:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler;

@end
