//
//  NewsCell+Weather.m
//  ProjectAdam
//
//  Created by shizhan on 2017/2/19.
//  Copyright © 2017年 ___GUSTPLUS___. All rights reserved.
//

#import "WeatherCell.h"
#import "Masonry.h"
#import "WeatherService.h"

const static NSInteger kTitleHeight = 50;
const static NSInteger kNewsCellMarginHorizontal = 10;
const static NSInteger kNewsCellMarginVertical = 15;
const static NSInteger kTitleLeftMargin = 20;
const static NSInteger kTitleTopMargin = 10;

const static int kIconWidth = 90;
const static int kIconLeftMargin = 15;
const static int kIconTopMargin = 15;

const static int kTimeRightMargin = 20;
const static int kTimeBottomMargin = 4;

const static int kIconLabelPadding = 10;

@interface WeatherCell()

@property (strong, nonatomic) UIView *background;
@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UIView *titleView;
@property (strong, nonatomic) UIView *mainView;

@property (strong, nonatomic) UILabel *updateDateLabel;
@property (strong, nonatomic) UILabel *updateTimeLabel;

@property (strong, nonatomic) UIImageView *weatherIcon;
@property (strong, nonatomic) UILabel *weatherLabel;
@property (strong, nonatomic) UILabel *detailLabel;

@property (strong, nonatomic) UILabel *temperatureLabel;
@property (strong, nonatomic) UILabel *temperatureRangeLabel;

@property (strong, nonatomic) UIActivityIndicatorView *loadingView;

@end

@implementation WeatherCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self setupUI];
        
        [self loadData];
    }
    return self;
}

-(void)setupUI
{
    self.backgroundColor = [UIColor clearColor];
    self.background = [[UIView alloc]initWithFrame:CGRectZero];
    self.background.backgroundColor = [UIColor whiteColor];
    self.background.layer.cornerRadius = 20;
    self.background.layer.masksToBounds = YES;
    self.background.clipsToBounds = YES;
    
    self.titleView = [[UIView alloc]initWithFrame:CGRectZero];
    self.titleView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    self.titleView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.titleView.layer.shadowRadius = 3;
    self.titleView.layer.shadowOpacity = 0.3;
    self.titleView.layer.shadowOffset = CGSizeMake(0, 3);
    [self.background addSubview:self.titleView];
    [self addSubview:self.background];
    
    self.title = [[UILabel alloc]initWithFrame:CGRectZero];
    self.title.font = [UIFont systemFontOfSize:24];
    self.title.textColor = [UIColor lightGrayColor];
    [self.titleView addSubview:self.title];
    
    self.mainView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.background addSubview:self.mainView];
    
    
    self.updateDateLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.titleView addSubview:self.updateDateLabel];
    self.updateTimeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.titleView addSubview:self.updateTimeLabel];
    
    CGRect iconFrame = CGRectMake(kIconLeftMargin, kIconTopMargin, kIconWidth, kIconWidth);
    self.weatherIcon = [[UIImageView alloc]initWithFrame:iconFrame];
    [self.mainView addSubview:self.weatherIcon];
    
    self.weatherLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.mainView addSubview:self.weatherLabel];
    self.weatherLabel.font = [UIFont systemFontOfSize:30];
    
    self.detailLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.mainView addSubview:self.detailLabel];
    self.detailLabel.font = [UIFont systemFontOfSize:15];
    self.detailLabel.numberOfLines = 0;
    
    self.temperatureLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.mainView addSubview:self.temperatureLabel];
    self.temperatureLabel.font = [UIFont systemFontOfSize:50];
    
    self.temperatureRangeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.mainView addSubview:self.temperatureRangeLabel];
    self.temperatureRangeLabel.font = [UIFont systemFontOfSize:25];
}

-(void)setWeatherCode:(NSString *)code
{
    UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", code]];
    if(!img)
    {
        img = [UIImage imageNamed:@"99.png"];
    }
    self.weatherIcon.image = img;
}

-(void)setupConstraints
{
    [self.background mas_makeConstraints:^(MASConstraintMaker *maker)
     {
         maker.left.equalTo(self.mas_left).with.offset(kNewsCellMarginHorizontal);
         maker.right.equalTo(self.mas_right).with.offset(-kNewsCellMarginHorizontal);
         maker.top.equalTo(self.mas_top).with.offset(kNewsCellMarginVertical);
         maker.bottom.equalTo(self.mas_bottom).with.offset(-kNewsCellMarginVertical);
     }];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *maker)
     {
         maker.left.equalTo(self.background.mas_left).with.offset(0);
         maker.right.equalTo(self.background.mas_right).with.offset(0);
         maker.top.equalTo(self.background.mas_top).with.offset(0);
         maker.height.equalTo(@(kTitleHeight)).priorityLow();
     }];
    [self.title mas_makeConstraints:^(MASConstraintMaker *maker)
     {
         maker.left.equalTo(self.titleView.mas_left).with.offset(kTitleLeftMargin);
         maker.top.equalTo(self.titleView.mas_top).with.offset(kTitleTopMargin);
     }];
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *maker)
     {
         maker.left.equalTo(self.background.mas_left).with.offset(0);
         maker.right.equalTo(self.background.mas_right).with.offset(0);
         maker.top.equalTo(self.titleView.mas_bottom).with.offset(0);
         maker.bottom.equalTo(self.background.mas_bottom).with.offset(0);
     }];
    [self.updateTimeLabel mas_makeConstraints:^(MASConstraintMaker *maker)
     {
         maker.right.equalTo(self.titleView.mas_right).with.offset(-kTimeRightMargin);
         maker.bottom.equalTo(self.titleView.mas_bottom).with.offset(-kTimeBottomMargin);
     }];
    [self.updateDateLabel mas_makeConstraints:^(MASConstraintMaker *maker)
     {
         maker.right.equalTo(self.titleView.mas_right).with.offset(-kTimeRightMargin);
         maker.bottom.equalTo(self.updateTimeLabel.mas_top).with.offset(0);
     }];
    [self.updateTimeLabel mas_makeConstraints:^(MASConstraintMaker *maker)
     {
         maker.right.equalTo(self.titleView.mas_right).with.offset(-kTimeRightMargin);
         maker.bottom.equalTo(self.titleView.mas_bottom).with.offset(-kTimeBottomMargin);
     }];
    [self.updateDateLabel mas_makeConstraints:^(MASConstraintMaker *maker)
     {
         maker.right.equalTo(self.titleView.mas_right).with.offset(-kTimeRightMargin);
         maker.bottom.equalTo(self.updateTimeLabel.mas_top).with.offset(0);
     }];
    [self.weatherLabel mas_makeConstraints:^(MASConstraintMaker *maker)
     {
         maker.centerY.equalTo(self.weatherIcon.mas_centerY).with.offset(0);
         maker.left.equalTo(self.weatherIcon.mas_right).with.offset(kIconLabelPadding);
     }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *maker)
     {
         maker.left.equalTo(self.weatherIcon.mas_left).with.offset(0);
         maker.top.equalTo(self.weatherIcon.mas_bottom).with.offset(0);
     }];
    [self.temperatureLabel mas_makeConstraints:^(MASConstraintMaker *maker)
     {
         maker.right.equalTo(self.mainView.mas_right).with.offset(-kTimeRightMargin);
         maker.centerY.equalTo(self.weatherLabel.mas_centerY).with.offset(0);
     }];
    [self.temperatureRangeLabel mas_makeConstraints:^(MASConstraintMaker *maker)
     {
         maker.right.equalTo(self.temperatureLabel.mas_right).with.offset(0);
         maker.top.equalTo(self.temperatureLabel.mas_bottom).with.offset(kTimeBottomMargin);
     }];
}

-(void)updateConstraints
{
    [self setupConstraints];
    
    [super updateConstraints];
}

-(void)loadData
{
    [self showLoading];
    NSDate *today = [NSDate date];
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy-MM-dd"];
    [WeatherService GetWeatherCacheAtDate: [format stringFromDate:today] selector:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
     {
         id content = nil;
         if (error)
         {
             NSLog(@"error %@", error.localizedDescription);
         }
         else
         {
             // 直接将data数据转成OC字符串(NSUTF8StringEncoding)；
             NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             NSLog(@"%@", dataString);
             if(![dataString isEqualToString:@""])
             {
                 @try
                 {
                     id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
                     id todayData = [NSJSONSerialization JSONObjectWithData: [json[@"today"] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
                     id curData = [NSJSONSerialization JSONObjectWithData: [json[@"cur"] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
                     
                     content = @{
                                 @"today":todayData,
                                 @"cur":curData
                                 };
                 }
                 @catch (NSException *exception)
                 {
                 }
             }
         }
         dispatch_async(dispatch_get_main_queue(), ^{
             [self setNews:content];
         });
     }];
    
}

-(void)setNews:(id)content
{
    [self hideLoading];
    
    if(content)
    {
        NSDictionary *cur = content[@"cur"];
        NSString *date = [cur[@"time"] substringToIndex:10];
        self.updateDateLabel.text = date;
        NSString *time = [cur[@"time"] substringWithRange:NSMakeRange(11, 8)];
        self.updateTimeLabel.text = time;
        
        NSDictionary *curWeather = cur[@"weather"];
        [self setWeatherCode:curWeather[@"code"]];
        self.weatherLabel.text = curWeather[@"text"];
        self.temperatureLabel.text = [NSString stringWithFormat:@"%@°c", curWeather[@"temperature"]];
        
        NSDictionary *today = content[@"today"];
        self.detailLabel.text = [NSString stringWithFormat:@"白天%@,%@%@级\n夜间%@,%@%@级", today[@"status1"], today[@"wind_dir1"], today[@"wind_pow1"], today[@"status2"], today[@"wind_dir2"], today[@"wind_pow2"]];
        
        self.temperatureRangeLabel.text = [NSString stringWithFormat:@"%@°c/%@°c", today[@"temp1"], today[@"temp2"]];
        
        _title.text = [NSString stringWithFormat:@"天气:%@", today[@"city"]];
    }
    else
    {
        [self setFailed];
    }
}

-(void)setFailed
{
    self.detailLabel.text = @"获取天气数据失败";
    [self setWeatherCode:@"99"];
}

-(UIActivityIndicatorView *)loadingView
{
    if(!_loadingView)
    {
        _loadingView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectZero];
        [self addSubview:_loadingView];
        
        _loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        _loadingView.transform = CGAffineTransformMake(3, 0, 0, 3, 0, 0);
        [_loadingView startAnimating];
        
        [_loadingView mas_makeConstraints:^(MASConstraintMaker *maker)
         {
             maker.center.equalTo(_mainView);
         }];
    }
    return _loadingView;
}

-(void)showLoading
{
    self.loadingView.hidden = NO;
}

-(void)hideLoading
{
    _loadingView.hidden = YES;
}


@end
