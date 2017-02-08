//
//  SpeechRecognizer.h
//  ProjectAdam
//
//  Created by shizhan on 2017/2/3.
//  Copyright © 2017年 ___GUSTPLUS___. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SpeechDelegate <NSObject>

@optional
-(void)onStart;
-(void)onEnd;
-(void)onCancel;
-(void)onResult:(NSArray *)s;
-(void)onError;
-(void)onVolumeChanged:(float)volume;

@end

@interface SpeechRecognizer : NSObject
@property(assign, nonatomic) NSInteger cancelTime;  //静音超时时间 0 ~ 10000
@property(assign, nonatomic) NSInteger endTime;  //静音结束时间 0 ~ 10000
@property(assign, nonatomic) NSInteger sampleRate; //16000 ~ 8000

@property(strong, nonatomic) id<SpeechDelegate> delegate;

+(instancetype)sharedInstance;

-(void) startListening;

-(void) setCancelTime:(NSInteger) time;
-(void) setEndTime:(NSInteger) time;
-(void) setSampleRate:(NSInteger)sampleRate;

@end
