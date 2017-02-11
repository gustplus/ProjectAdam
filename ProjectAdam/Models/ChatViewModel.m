//
//  ChatViewModel.m
//  ProjectAdam
//
//  Created by shizhan on 2017/2/8.
//  Copyright © 2017年 ___GUSTPLUS___. All rights reserved.
//

#import "ChatViewModel.h"
#import "ChatMessage.h"
#import "MessageCell.h"

@interface ChatViewModel()
    @property (strong, nonatomic) NSMutableArray *messages;
@end

@implementation ChatViewModel

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        self.messages = [[NSMutableArray alloc] initWithCapacity:5];
    }
    return self;
}

#pragma mark    UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}

-(CGFloat)heightOfIndexPath:(NSIndexPath*) indexPath
{
    BaseChatMessage *msg = self.messages[indexPath.row];
    return [msg heightOfCell];
}

-(void)sendTextMessage:(NSString *)text
{
    TextChatMessage *msg = [[TextChatMessage alloc] init];
    msg.text = text;
    msg.owner = kMsgOwnerSelf;
    [self.messages addObject:msg];
}

-(void)getMessage:(BaseChatMessage *)msg
{
    [self.messages addObject:msg];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseChatMessage *msg = self.messages[indexPath.row];
    
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:kChatMessageIdentifier forIndexPath:indexPath];
    
    [cell setMsg:msg];
    
    return cell;
}

@end
