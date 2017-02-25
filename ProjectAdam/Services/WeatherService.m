//
//  WeatherService.m
//  ProjectAdam
//
//  Created by shizhan on 2017/2/12.
//  Copyright © 2017年 ___GUSTPLUS___. All rights reserved.
//

#import "WeatherService.h"
#import "HttpUtils.h"

@implementation WeatherService

+(void)GetWeatherCacheAtDate:(NSString *)date selector:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler
{
//    NSString *url = @"http://16622bl937.imwork.net/adam/services/weather.php";
    NSString *url = @"http://192.168.1.108/adam/services/weather.php";
    [HttpUtils PostToUrl:url withEncoding:NSUTF8StringEncoding withParams:nil withHeaders:nil selector:completionHandler];
}

+(void)GetWeatherAtCity:(NSString *)city atDay:(NSInteger)day selector:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler
{
//    NSDictionary *params = @{@"city": city, @"password":@"DJOYnieT8234jlsK", @"day":[NSNumber numberWithInteger:day]};
//    [HttpUtils GetFromUrl:@"http://php.weather.sina.com.cn/xml.php" withEncoding:CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000) withParams:params withHeaders:nil selector:completionHandler];
    
    NSDictionary *params = @{@"location": city, @"key":@"vofsbu7viqnoupkb", @"language":@"zh-Hans", @"unit":@"c"};
    [HttpUtils GetFromUrl:@"https://api.thinkpage.cn/v3/weather/now.json" withEncoding:CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingUTF8) withParams:params withHeaders:nil selector:completionHandler];

}

@end
