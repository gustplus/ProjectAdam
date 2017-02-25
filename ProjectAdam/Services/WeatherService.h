//
//  WeatherService.h
//  ProjectAdam
//
//  Created by shizhan on 2017/2/12.
//  Copyright © 2017年 ___GUSTPLUS___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherService : NSObject

+(void)GetWeatherCacheAtDate:(NSString *)date selector:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler;

+(void)GetWeatherAtCity:(NSString *)city atDay:(NSInteger)day selector:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler;

@end
