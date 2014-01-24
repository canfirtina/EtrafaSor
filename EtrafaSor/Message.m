//
//  Message.m
//  EtrafaSor
//
//  Created by Can Firtina on 22/01/14.
//  Copyright (c) 2014 Can Firtina. All rights reserved.
//

#import "Message.h"

@interface Message ()
@property (strong, nonatomic) NSMutableArray *messageStatusObservers;
@end

@implementation Message

@synthesize text = _text;
@synthesize totalVoteValue = _totalVoteValue;
@synthesize owner = _owner;
@synthesize question = _question;
@synthesize isSent = _isSent;
@synthesize messageStatusObservers = _messageStatusObservers;

#pragma mark - Setters & Getters

- (NSMutableArray *)messageStatusObservers {
    
    if( !_messageStatusObservers) _messageStatusObservers = [NSMutableArray array];
    
    return _messageStatusObservers;
}

//message status notification is triggered there
- (void)setIsSent:(BOOL)isSent {
    
    _isSent = isSent;
    [self notifyMessageStatusObservers];
}

# pragma mark - Allocations
+ (Message *)messageWithText:(NSString *)text owner:(Profile *)owner inQuestion:(Question *)question {
    
    Message *newMessage = [[Message alloc] init];
    newMessage.text = text;
    newMessage.totalVoteValue = 0;
    newMessage.owner = owner;
    newMessage.question = question;
    newMessage.isSent = NO;
    
    return newMessage;
}

#pragma mark - Custom Notification for Message Status
- (void)attachObserverForMessageStatusChange:(id<MessageStatusObserver>)observer {
    
    if( ![self.messageStatusObservers containsObject:observer])
        [self.messageStatusObservers addObject:observer];
}
- (void)dettachObserverForMessageStatusChange:(id<MessageStatusObserver>)observer {
    
    if( [self.messageStatusObservers containsObject:observer])
        [self.messageStatusObservers removeObject:observer];
}
- (void)notifyMessageStatusObservers{
    
    for (id<MessageStatusObserver> observer in self.messageStatusObservers) {
        [observer updateMessageStatus];
    }
}

@end