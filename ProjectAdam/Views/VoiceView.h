//
//  VoiceView.h
//  ProjectAdam
//
//  Created by shizhan on 2017/2/3.
//  Copyright © 2017年 ___GUSTPLUS___. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, VoiceViewStyle)
{
    VoiceViewStyleTop,
    VoiceViewStyleMiddle,
    VoiceViewStyleBottom
};

typedef NS_ENUM(NSUInteger, RecognizeType)
{
    ReconizeTypeDigital,
    ReconizeTypeAnalog
};

@interface VoiceView : UIView
@property(assign, nonatomic)int slotPadding;
@property(assign, nonatomic)int padding;
@property(assign, nonatomic)int slotScale;

@property(assign, nonatomic) VoiceViewStyle style;
@property(assign, nonatomic) RecognizeType recognizeType;

@property(assign, nonatomic) NSUInteger slotCount;

-(instancetype)initWithFrame:(CGRect)frame;
-(instancetype)initWithCoder:(NSCoder *)aDecoder;

-(void)setVolume:(float)value;

@end
