//
//  SwipeInteractAnimator.m
//  ProjectAdam
//
//  Created by shizhan on 2017/2/11.
//  Copyright © 2017年 ___GUSTPLUS___. All rights reserved.
//

#import "SwipeInteractiveTransition.h"

@interface SwipeInteractiveTransition()

@property (assign, nonatomic)UIRectEdge startEdge;
@property (weak, nonatomic) UIScreenEdgePanGestureRecognizer *recognizer;
@property (weak, nonatomic) id<UIViewControllerContextTransitioning> context;
@end

@implementation SwipeInteractiveTransition

-(instancetype)initWithGestureRecognizer:(UIScreenEdgePanGestureRecognizer *)recognizer
{
    self = [super init];
    if(self)
    {
        self.recognizer = recognizer;
        self.startEdge = recognizer.edges;
        [self.recognizer addTarget:self action:@selector(gestureUpdate:)];
    }
    return self;
}

-(void)gestureUpdate:(UIScreenEdgePanGestureRecognizer *)recognizer
{
    CGFloat percent = [self percentOfMotion:recognizer];
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged:
            [self updateInteractiveTransition:percent];
            break;
        case UIGestureRecognizerStateEnded:
        {
            if(percent > 0.2f)
            {
                [self finishInteractiveTransition];
            }
            else
            {
                [self cancelInteractiveTransition];
            }
        }
            break;
        default:
            [self cancelInteractiveTransition];
            break;
    }
}

-(void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    self.context = transitionContext;
    [super startInteractiveTransition:transitionContext];
}

-(CGFloat)percentOfMotion:(UIScreenEdgePanGestureRecognizer *)recognizer
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIView *containerView = [self.context containerView];
    CGPoint location = [recognizer locationInView:containerView];
    switch (self.startEdge) {
        case UIRectEdgeLeft:
            return location.x / size.width;
        case UIRectEdgeRight:
            return 1 - location.x / size.width;
        case UIRectEdgeTop:
            return (location.y / size.height);
        case UIRectEdgeBottom:
            return (1 - location.y / size.height);
        default:
            break;
    }
    return 0;
}

@end
