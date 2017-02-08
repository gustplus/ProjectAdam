//
//  LoopQueue.m
//  ProjectAdam
//
//  Created by shizhan on 2017/2/3.
//  Copyright © 2017年 ___GUSTPLUS___. All rights reserved.
//

#import "LoopQueue.h"

@implementation LoopQueue
const static int kDefaultCapacity = 6;

-(instancetype)init
{
    return [self initWithCapacity:kDefaultCapacity];
}

-(instancetype)initWithCapacity:(NSUInteger)cap
{
    self = [super init];
    if(self)
    {
        self.capacity = cap;
        _count = 0;
        
        _head = NULL;
        _tail = _head;
    }
    return self;
}

-(void)push:(float)data
{
    if(self.count < self.capacity)
    {
        QueueNode *node = (QueueNode *)malloc(sizeof(QueueNode));
        if(self.head)
        {
            node->next = _tail->next;
            node->prev = _tail;
            _tail->next->prev = node;
            _tail->next = node;
            _tail = node;
        }
        else
        {
            _head = node;
            _head->next = _head;
            _head->prev = node;
            _tail = _head;
        }
        
        ++_count;
    }
    else
    {
        _tail = _head;
        _head = _head->next;
    }
    _tail->data = data;
}

-(BOOL)isLast:(QueueNode * _Nonnull)node
{
    return node->next == _head;
}

@end
