//
//  ViewController.m
//  ProjectAdam
//
//  Created by shizhan on 2016/12/20.
//  Copyright © 2016年 ___GUSTPLUS___. All rights reserved.
//

#import "SettingViewController.h"
#import "GraphicUtils.h"
#import "CircleSlideData.h"
#import "VoiceView.h"
#import "SpeechRecognizer.h"

static NSString *kRecognizerEndTimeKey = @"endtime";
static NSString *kRecognizerCancelTimeKey = @"canceltime";
static NSString *kRecognizerSampleRateKey = @"samplerate";

@interface SettingViewController ()<SliderDelegate>
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.settiingView.highlightColor = ColorMake(1, 1, 1);
    
    self.settiingView.backgroundColor = [UIColor darkGrayColor];
    
    [self setupSettings];
}

-(void)setupSettings
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSInteger cancelTime = [ud integerForKey:kRecognizerCancelTimeKey];
    if(0 == cancelTime)
    {
        cancelTime = 4000;
    }
    CircleSlideData *data = [[CircleSlideData alloc]initWithMin:0 AndInterval:10000];
    data.tag = 0;
    data.value = cancelTime;
    Color red = ColorMake(1, 0, 0);
    [self.settiingView addSlider:data WithColor:red];
    data.delegate = self;
    
    NSInteger endTime = [ud integerForKey:kRecognizerEndTimeKey];
    if(0 == endTime)
    {
        endTime = 700;
    }
    CircleSlideData *data2 = [[CircleSlideData alloc]initWithMin:0 AndInterval:10000];
    data2.tag = 1;
    data2.value = endTime;
    Color green = ColorMake(0, 1, 0);
    [self.settiingView addSlider:data2 WithColor:green];
    data2.delegate = self;
    
    CircleSlideData *data3 = [[CircleSlideData alloc]initWithMin:0 AndInterval:20];
    data3.tag = 2;
    data3.value = 0;
    Color blue = ColorMake(0, 0, 1);
    [self.settiingView addSlider:data3 WithColor:blue];
    data3.delegate = self;
}

-(void)valueChanged:(CGFloat)newvalue withTag:(NSInteger)tag
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    switch (tag) {
        case 0:
            [SpeechRecognizer sharedInstance].cancelTime = newvalue;
            
            [ud setInteger:newvalue forKey:kRecognizerCancelTimeKey];
            break;
        case 1:
            [SpeechRecognizer sharedInstance].endTime = newvalue;

            [ud setInteger:newvalue forKey:kRecognizerEndTimeKey];
            break;
        case 2:
            break;
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
