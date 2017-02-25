//
//  HttpUtils.h
//  ProjectAdam
//
//  Created by shizhan on 2017/2/12.
//  Copyright © 2017年 ___GUSTPLUS___. All rights reserved.
//

#import <Foundation/Foundation.h>

const static NSString *kParamKeyTimeout = @"ktimeout";

@interface HttpUtils : NSObject

+(void) GetFromUrl:(NSString *)url withEncoding: (NSStringEncoding) encoding withParams:(NSDictionary *)params withHeaders:(NSDictionary *)headers selector:(void (^)(NSData *, NSURLResponse *, NSError *))completionHandler;

+(void) PostToUrl:(NSString *)url withEncoding: (NSStringEncoding) encoding withParams:(NSDictionary *)params withHeaders:(NSDictionary *)headers selector:(void (^)(NSData *, NSURLResponse *, NSError *))completionHandler;

@end
