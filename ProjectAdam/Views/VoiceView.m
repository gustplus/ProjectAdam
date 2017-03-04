//
//  VoiceView.m
//  ProjectAdam
//
//  Created by shizhan on 2017/2/3.
//  Copyright © 2017年 ___GUSTPLUS___. All rights reserved.
//

#import "VoiceView.h"
#import "LoopQueue.h"
#import "MathUtils.h"

const static int kDefaultSlotPadding = 5;
const static int kDefaultPadding = 20;
const static int kDefaultScale = 4;

@interface VoiceView ()
@property(strong, nonatomic)LoopQueue *queue;
@end

@implementation VoiceView

-(void)setDefaults
{
    self.queue = [[LoopQueue alloc]init];
    
    self.slotPadding = kDefaultSlotPadding;
    self.padding = kDefaultPadding;
    self.slotScale = kDefaultScale;
    self.style = VoiceViewStyleMiddle;
    self.recognizeType = ReconizeTypeAnalog;
    self.backgroundColor = [UIColor whiteColor];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self setDefaults];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self setDefaults];
    }
    return self;
}

-(void)setVolume:(float)value
{
    static float lastVolume = 0;
    static float interpolationPercent = 1.0f;
    
    if(self.recognizeType == ReconizeTypeAnalog)
    {
        BOOL bigChange = fabsf(value - lastVolume) >= 3;
        if(bigChange)
        {
            interpolationPercent-= 0.2f;
            interpolationPercent = interpolationPercent > 0 ? interpolationPercent : 0.0f;
            value = [MathUtils cosInterpolationBetween:lastVolume and:value at:interpolationPercent];
        }
        else
        {
            interpolationPercent = 1.0f;
        }
    }
    lastVolume = value;
    [self.queue push:value];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat slotWidth = (rect.size.width - self.padding * 2 - (self.slotPadding * self.queue.capacity - 1)) / self.queue.capacity;
    CGContextSetLineWidth(context, slotWidth);
    CGContextSetRGBFillColor(context, 0, 0, 1, 1);
    
    CGFloat stride = slotWidth + self.slotPadding;
    
    NSUInteger count = self.queue.count;
    
    CGFloat startPointX = self.padding + (count - 1) * stride;
    QueueNode *node = self.queue.head;
    
    CGFloat y = 0;
    switch(self.style)
    {
        case VoiceViewStyleBottom:
            y = rect.size.height - self.padding;
            
            for (NSUInteger i = 0; i < count; ++i)
            {
                int x = startPointX - i * stride;
                float volume = node->data * self.slotScale;
                CGContextFillRect(context, CGRectMake(x, y, slotWidth, -volume));
                node = node->next;
            }
            
            break;
        case VoiceViewStyleTop:
            y = self.padding;
            
            for (NSUInteger i = 0; i < count; ++i)
            {
                int x = startPointX - i * stride;
                float volume = node->data * self.slotScale;
                CGContextFillRect(context, CGRectMake(x, y, slotWidth, volume));
                node = node->next;
            }
            break;
        case VoiceViewStyleMiddle:
        default:
            y = rect.size.height * 0.5;
            
            for (NSUInteger i = 0; i < count; ++i)
            {
                int x = startPointX - i * stride;
                float volume = node->data * self.slotScale;
                CGContextFillRect(context, CGRectMake(x, y - volume, slotWidth, volume * 2));
                node = node->next;
            }
            break;
    }
}

-(void)setSlotCount:(NSUInteger)slotCount
{
    self.queue.capacity = slotCount;
}

@end
