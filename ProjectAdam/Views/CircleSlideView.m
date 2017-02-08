//
//  CircleSlideView.m
//  ProjectAdam
//
//  Created by shizhan on 2017/2/1.
//  Copyright © 2017年 ___GUSTPLUS___. All rights reserved.
//

#import "CircleSlideView.h"
#import "MathUtils.h"

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
