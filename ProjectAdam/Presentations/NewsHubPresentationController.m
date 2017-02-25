//
//  NewsHubPresentationController.m
//  ProjectAdam
//
//  Created by shizhan on 2017/2/11.
//  Copyright © 2017年 ___GUSTPLUS___. All rights reserved.
//

#import "NewsHubPresentationController.h"
#import "SwipeInteractiveTransition.h"
#import "Marco.h"

@interface NewsHubPresentationController()

@property (strong, nonatomic) UIView *maskView;

@property (strong, nonatomic) UIScreenEdgePanGestureRecognizer *swipeRecognizer;

@end


@implementation NewsHubPresentationController

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self;
}

-(id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator
{
    if(self.recognizer)
    {
        return [[SwipeInteractiveTransition alloc]initWithGestureRecognizer:self.recognizer];
    }
    return nil;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self;
}

-(id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
    if(self.recognizer)
    {
        return [[SwipeInteractiveTransition alloc]initWithGestureRecognizer:self.recognizer];
    }
    return nil;
}

-(UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    return self;
}

-(CGFloat) transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.2f;
}

-(void)presentationTransitionWillBegin
{
    self.maskView = [[UIView alloc] initWithFrame: [UIScreen mainScreen].bounds];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0;
    UITapGestureRecognizer *dismissRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss:)];
    [self.maskView addGestureRecognizer:dismissRecognizer];
    [self.containerView addSubview:self.maskView];
    
    self.swipeRecognizer = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(swipe:)];
    self.swipeRecognizer.edges = UIRectEdgeLeft;
    [self.maskView addGestureRecognizer:self.swipeRecognizer];
}

-(void)swipe:(UIScreenEdgePanGestureRecognizer *)recognizer
{
    if(recognizer.state == UIGestureRecognizerStateBegan)
    {
        NewsHubPresentationController *presentationController = (NewsHubPresentationController *)self.presentedViewController.transitioningDelegate;
        presentationController.recognizer = self.swipeRecognizer;
        self.presentedViewController.transitioningDelegate = presentationController;
        [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    }
}


-(void)dismiss:(UITapGestureRecognizer *)recognizer
{
    if(recognizer.state == UIGestureRecognizerStateEnded)
    {
        self.recognizer = nil;
        [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)presentationTransitionDidEnd:(BOOL)completed
{
    [self.containerView willRemoveSubview:self.maskView];
    self.maskView = nil;
}

-(CGRect)frameOfPresentedViewInContainerView
{
    CGFloat screenWidth = ScreenWidth;
    CGFloat startX = ScreenWidth * 0.1;
    return CGRectMake(startX, 0, screenWidth - startX, ScreenHeight);
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIViewController *toController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    CGRect fromFinalFrame = [transitionContext initialFrameForViewController:fromController];
    CGRect toFinalFrame = [transitionContext finalFrameForViewController:toController];
    
    BOOL isPresenting = toController.presentingViewController == fromController;
    
    if(isPresenting)
    {
        CGRect toInitFrame = toFinalFrame;
        toInitFrame.origin.x = ScreenWidth;
        toView.frame = toInitFrame;
    }
    else
    {
        fromFinalFrame.origin.x = ScreenWidth;
    }
    
    [[transitionContext containerView] addSubview:toView];
    
    CGFloat duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration animations:^{
        if(isPresenting)
        {
            toView.frame = toFinalFrame;
            self.maskView.alpha = 0.5;
        }
        else
        {
            fromView.frame = fromFinalFrame;
            self.maskView.alpha = 0;
        }
    } completion:^(BOOL isFinished)
    {
        BOOL isCancel = [transitionContext transitionWasCancelled];
        if(isCancel || (isFinished && !isPresenting))
        {
            [toView removeFromSuperview];
        }
        [transitionContext completeTransition:!isCancel];
    }];
}

@end
