//
//  SwipeInteractAnimator.h
//  ProjectAdam
//
//  Created by shizhan on 2017/2/11.
//  Copyright © 2017年 ___GUSTPLUS___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwipeInteractiveTransition : UIPercentDrivenInteractiveTransition

-(instancetype)initWithGestureRecognizer:(UIScreenEdgePanGestureRecognizer *)recognizer;

@end
