//
//  HttpUtils.m
//  ProjectAdam
//
//  Created by shizhan on 2017/2/12.
//  Copyright © 2017年 ___GUSTPLUS___. All rights reserved.
//

#import "HttpUtils.h"

@implementation HttpUtils

+(void) GetFromUrl:(NSString *)url withEncoding: (NSStringEncoding) encoding withParams:(NSDictionary *)params withHeaders:(NSDictionary *)headers selector:(void (^)(NSData *, NSURLResponse *, NSError *))completionHandler
{
    NSInteger timeout = 5;
    if(params)
    {
        NSMutableString *paramStr = [NSMutableString stringWithFormat:@"%@?", url];
        for (NSString *key in params)
        {
            if(key == kParamKeyTimeout)
            {
                timeout = [params[key] integerValue];
                continue;
            }
            
            if(paramStr.length > 0)
            {
                [paramStr appendString:@"&"];
            }
            [paramStr appendFormat:@"%@=%@", key, params[key]];
        }
        
        url =  [paramStr stringByAddingPercentEscapesUsingEncoding:encoding];
        NSLog(@"%@", url);
    }
    
    NSURL *URL = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
    request.timeoutInterval = timeout;
    
    if(headers)
    {
        for(NSString *key in headers)
        {
            [request setValue:headers[key] forHTTPHeaderField:key];
        }
    }
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:completionHandler];
    [task resume];
}

+(void) PostToUrl:(NSString *)url withEncoding: (NSStringEncoding) encoding withParams:(NSDictionary *)params withHeaders:(NSDictionary *)headers selector:(void (^)(NSData *, NSURLResponse *, NSError *))completionHandler
{
    NSInteger timeout = 5;
    
    NSURL *URL = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
    if(params)
    {
        if(params)
        {
            NSMutableString *paramStr = [[NSMutableString alloc]init];
            for (NSString *key in params)
            {
                if(key == kParamKeyTimeout)
                {
                    timeout = [params[key] integerValue];
                    continue;
                }
                
                if(paramStr.length > 0)
                {
                    [paramStr appendString:@"&"];
                }
                [paramStr appendFormat:@"%@=%@", key, params[key]];
            }
            request.HTTPBody = [paramStr dataUsingEncoding:NSUTF8StringEncoding];
        }
    }
    
    request.timeoutInterval = timeout;
    request.HTTPMethod = @"POST";
    
    if(headers)
    {
        for(NSString *key in headers)
        {
            [request setValue:headers[key] forHTTPHeaderField:key];
        }
    }
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:completionHandler];
    [task resume];
}

@end
