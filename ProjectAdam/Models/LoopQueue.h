//
//  LoopQueue.h
//  ProjectAdam
//
//  Created by shizhan on 2017/2/3.
//  Copyright © 2017年 ___GUSTPLUS___. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct QueueNode
{
    struct QueueNode *next;
    struct QueueNode *prev;
    
    float data;
} QueueNode;

@interface LoopQueue : NSObject
@property(assign, nonatomic) NSUInteger capacity;
@property(assign, nonatomic, readonly) NSUInteger count;
@property(assign, nonatomic, readonly) QueueNode *head;
@property(assign, nonatomic, readonly) QueueNode *tail;

-(instancetype)init;
-(instancetype)initWithCapacity:(NSUInteger)cap;

-(void)setCapacity:(NSUInteger)capacity;

-(void)push:(float)data;


@end
