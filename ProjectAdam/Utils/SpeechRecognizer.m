//
//  SpeechRecognizer.m
//  ProjectAdam
//
//  Created by shizhan on 2017/2/3.
//  Copyright © 2017年 ___GUSTPLUS___. All rights reserved.
//

#import "SpeechRecognizer.h"
#import <iflyMSC/iflyMSC.h>

@interface SpeechRecognizer()<IFlySpeechRecognizerDelegate>
@property (strong, nonatomic) IFlySpeechRecognizer *recognizer;
@property (strong, nonatomic) NSMutableArray *words;

@end

@implementation SpeechRecognizer

+(instancetype)sharedInstance
{
    static SpeechRecognizer *instance = NULL;
    if(!instance)
    {
        instance = [[SpeechRecognizer alloc]init];
    }
    return instance;
}

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        _recognizer = [IFlySpeechRecognizer sharedInstance];
        [_recognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
        [_recognizer setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
        [_recognizer setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
        [_recognizer  setParameter:@"" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
        _recognizer.delegate = self;
        
        self.words = [[NSMutableArray alloc]initWithCapacity:10];
    }
    return self;
}

-(void) startListening
{
    [_recognizer startListening];
    [self.words removeAllObjects];
}


-(void) decodeResult:(NSString *)jsonStr
{
    NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    NSArray *ws = json[@"ws"];
    for(NSDictionary *dic in ws)
    {
        NSArray *cw = dic[@"cw"];
        for(NSDictionary *w in cw)
        {
            [self.words addObject:w[@"w"]];
        }
    }
}

- (void) onResults:(NSArray *) results isLast:(BOOL)isLast
{
    NSDictionary *dict = results[0];
    for (NSString *key in dict) {
        [self decodeResult:key];
    }
    
    if(isLast && self.delegate && [self.delegate respondsToSelector:@selector(onResult:)])
    {
        [self.delegate onResult:[self.words copy]];
    }
}

- (void)onError: (IFlySpeechError *) error
{
//    NSLog(@"%s",__func__);
    NSString *text ;
    
    if (error.errorCode != 0 )
    {
        text = [NSString stringWithFormat:@"发生错误：%d %@", error.errorCode,error.errorDesc];
        NSLog(@"%@",text);
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(onError)])
        {
            [self.delegate onError];
        }
    }
}
//停止录音回调
- (void) onEndOfSpeech
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(onEnd)])
    {
        [self.delegate onEnd];
    }
}
//开始录音回调
- (void) onBeginOfSpeech
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(onStart)])
    {
        [self.delegate onStart];
    }
}
//音量回调函数
- (void) onVolumeChanged: (int)volume
{
//    NSLog(@"volume %d", volume);
    if(self.delegate && [self.delegate respondsToSelector:@selector(onVolumeChanged:)])
    {
        [self.delegate onVolumeChanged:volume];
    }
}
//会话取消回调
- (void) onCancel
{
    
}

-(void) setCancelTime:(NSInteger) time
{
    if(time >= 0 && time <= 10000)
    {
        [_recognizer setParameter:[NSString stringWithFormat:@"%ld", time] forKey:[IFlySpeechConstant VAD_BOS]];
    }
}

-(void) setEndTime:(NSInteger) time
{
    if(time >= 0 && time <= 10000)
    {
        
        [_recognizer setParameter:[NSString stringWithFormat:@"%ld", time] forKey:[IFlySpeechConstant VAD_EOS]];
    }
}

-(void) setSampleRate:(NSInteger)sampleRate
{
    if(sampleRate == 8000 || sampleRate == 16000)
    {
        [_recognizer setParameter:[NSString stringWithFormat:@"%ld", sampleRate] forKey:[IFlySpeechConstant SAMPLE_RATE]];
    }
}

@end
