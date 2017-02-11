//
//  CircleSlideView.m
//  ProjectAdam
//
//  Created by shizhan on 2017/2/1.
//  Copyright © 2017年 ___GUSTPLUS___. All rights reserved.
//

#import "CircleSlideView.h"
#import "MathUtils.h"
#import "CircleSlideData.h"

@implementation CircleSlideWrapper

-(void)setColorWithR:(float)red G:(float)green B:(float)blue
{
    self.color = ColorMake(red, green, blue);
}

-(CGPoint)headPoint
{
    float angle = (self.data.value - self.data.min) / self.data.interval * 360;
    angle = 90 - angle;     //translate angle to normal x-y coordinater
    float rad = ANGLE_TO_RADIUS(angle);
    float offsetX = cosf(rad) * self.radius;
    float offsetY = sinf(rad) * self.radius;
    return CGPointMake(self.center.x + offsetX, self.center.y - offsetY);
}

-(BOOL) isPointIn:(CGPoint)point
{
    CGPoint head = [self headPoint];
    return [MathUtils isPoint:point InCircleAt:head WithRadius:self.lineWidth * 2];
}

-(NSInteger)pointAngle:(CGPoint)point
{
    float offsetX = point.x - self.center.x;
    float offsetY = point.y - self.center.y;
    float tan = offsetY / offsetX;
    float rad = atanf(tan);
    NSInteger angle = (NSInteger)RADIUS_TO_ANGLE(rad);
    if(offsetX < 0)
    {
        angle += 180;
    }
    return 90 + angle;
}

-(void)beginTouch:(CGPoint) point
{
    float val = self.data.value - self.data.min;
    self.preAngle = (NSUInteger)(val / self.data.interval * 360);
    if(self.preAngle == 0)
    {
        self.state = kStateReachBottom;
    }
    else if(self.preAngle == 360)
    {
        self.state = kStateReachTop;
    }
}

-(NSInteger)calculateFinalAngle:(NSInteger) angle
{
    if(self.state == kStateUp && angle < 90 && self.preAngle > 270)
    {
        self.state = kStateReachTop;
        angle = 360;
    }
    else if(self.state == kStateDown && (angle - self.preAngle) > 180)
    {
        self.state = kStateReachBottom;
        angle = 0;
    }
    else if(self.state == kStateReachTop)
    {
        if(angle > 270)
        {
            self.state = kStateDown;
        }
        else
        {
            angle = 360;
        }
    }
    else if(self.state == kStateReachBottom)
    {
        if(angle < 90)
        {
            self.state = kStateUp;
        }
        else
        {
            angle = 0;
        }
    }
    
    if(self.preAngle < angle)
    {
        self.state = kStateUp;
    }
    else if(self.preAngle > angle)
    {
        self.state = kStateDown;
    }
    return angle;
}

-(void)moveTouch:(CGPoint) point
{
    NSInteger angle = [self pointAngle:point];
    
    angle = [self calculateFinalAngle:angle];
    
    self.data.value = self.data.min + self.data.interval * angle / 360;
    self.preAngle = angle;
}

-(void)endTouch:(CGPoint) point
{
    NSInteger angle = [self pointAngle:point];
    
    angle = [self calculateFinalAngle:angle];
    
    [self.data setValueEnd: self.data.min + self.data.interval * angle / 360 ];
    self.state = kStateNone;
    
}

-(NSInteger)startAngle
{
    return [MathUtils getAngleInCGContext:0];
}

-(NSInteger)endAngle
{
    float val = self.data.value - self.data.min;
    NSUInteger angle = (NSUInteger)(val / self.data.interval * 360);
    return [MathUtils getAngleInCGContext:angle];
}

@end

@interface CircleSlideView()

@property(strong, nonatomic) NSMutableArray *sliders;
@property(strong, nonatomic) CircleSlideWrapper *curSlider;

@end

@implementation CircleSlideView

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        self.curSlider = NULL;
        self.sliders = [NSMutableArray arrayWithCapacity:2];
        self.backColor = ColorMake(0.2, 0.2, 0.2);
        self.slotPadding = 6;
        self.padding = 30;
        self.centerPadding = 30;
    }
    return self;
}

-(void)addSlider:(CircleSlideData *)data WithColor:(Color) color
{
    CircleSlideWrapper *wrapper = [[CircleSlideWrapper alloc] init];
    wrapper.data = data;
    wrapper.color = color;
    wrapper.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    [self.sliders addObject:wrapper];
    
    NSInteger count = [self.sliders count];
    float width = 0;
    if(self.frame.size.width > self.frame.size.height)
    {
        width = self.frame.size.height;
    }
    else
    {
        width = self.frame.size.width;
    }

    float lineWidth = (width * 0.5 - self.padding - self.centerPadding - (count - 1) * self.slotPadding)/(count * 2);
    
    for(int idx = 0; idx < count; ++idx)
    {
        CircleSlideWrapper *wrapper = [self.sliders objectAtIndex:idx];
        wrapper.lineWidth = lineWidth;
        wrapper.radius = self.centerPadding + (1 + idx) * (lineWidth + self.slotPadding);
    }
    
    [self setNeedsDisplay];
}

-(void)updateSliders
{
    NSInteger count = [self.sliders count];
    float width = 0;
    if(self.frame.size.width > self.frame.size.height)
    {
        width = self.frame.size.height;
    }
    else
    {
        width = self.frame.size.width;
    }
    
    for(int idx = 0; idx < count; ++idx)
    {
        CircleSlideWrapper *wrapper = [self.sliders objectAtIndex:idx];
        wrapper.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self updateSliders];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    for(CircleSlideWrapper *wrapper in self.sliders)
    {
        [self drawWrapper:wrapper WithContext:context];
    }
}

-(void)drawWrapper:(CircleSlideWrapper *)wrapper WithContext:(CGContextRef) context
{
//    [GraphicUtils DrawCircle:wrapper withContext:context withColor:self.backColor withLineWidth:wrapper.lineWidth];
    if(wrapper == self.curSlider)
    {
        [GraphicUtils DrawCircleSlide:wrapper withContext:context withLineWidth:wrapper.lineWidth + 4 withColor: self.highlightColor];
    }
    else
    {
//        [GraphicUtils DrawCircleSlide:wrapper withContext:context withLineWidth:wrapper.lineWidth + 4 withColor: ColorMake(wrapper.color.red - 0.2, wrapper.color.green - 0.2, wrapper.color.blue - 0.2)];
    }
    [GraphicUtils DrawCircleSlider:wrapper withContext:context];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    for(CircleSlideWrapper *wrapper in self.sliders)
    {
        if([wrapper isPointIn:point])
        {
            self.curSlider = wrapper;
            [wrapper beginTouch:point];
            [self setNeedsDisplay];
            return;
        }
    }
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if(self.curSlider)
    {
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        
        [self.curSlider moveTouch:point];
        [self setNeedsDisplay];
    }
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if(self.curSlider)
    {
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];

        [self.curSlider endTouch: point];
        self.curSlider = NULL;
    }
}

@end
