//
//  Question.m
//  EtrafaSor
//
//  Created by Can Firtina on 22/01/14.
//  Copyright (c) 2014 Can Firtina. All rights reserved.
//

#import "Question.h"
#import "Message.h"
#import "EtrafaSorHTTPRequestHandler.h"

@implementation Question

@synthesize coordinate = _coordinate;
@synthesize title = _title;
@synthesize subtitle = _subtitle;
@synthesize messages = _messages;
@synthesize topic = _topic;
@synthesize isSolved = _isSolved;

#pragma mark - Setters & Getters

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    
    _coordinate.latitude = newCoordinate.latitude;
    _coordinate.longitude = newCoordinate.longitude;
}

- (NSString *)title {
    
    if( self.topic.length > 20){
        
        return [NSString stringWithFormat:@"%@...", [self.topic substringToIndex:17]];
    }
    
    return self.topic;
}

- (NSString *)subtitle {
    
    NSString *firstMessage = ((Message *)[self.messages firstObject]).text;
    
    if( firstMessage.length > 25){
        
        return [NSString stringWithFormat:@"%@...", [firstMessage substringToIndex:22]];
    }
    
    return firstMessage;
}

- (NSArray *)messages {
    
    if( !_messages){
        _messages = [NSArray array];
    }
    
    return _messages;
}

#pragma mark - Property Change

- (void)addMessage:(Message *)message {
    
    NSMutableArray *mutableCopy = [self.messages mutableCopy];
    [mutableCopy addObject:message];
    _messages = [mutableCopy copy];
}
- (void)postMessage:(NSString *)text forUser:(Profile *)user usingBlock:(postCompletionBlock)completionBlock {
    
    Message *message = [Message messageWithText:text owner:user inQuestion:self atDate:[NSDate date]];
    [self addMessage:message];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        BOOL success = [EtrafaSorHTTPRequestHandler postMessage:message];
        message.isSent = success;
        completionBlock(success);
    });
}

#pragma mark - Allocations

+ (Question *)questionWithTopic:(NSString *)topic questionMessage:(NSString *)question owner:(Profile *)owner {
    
    Question *newQuestion = [[Question alloc] init];
    newQuestion.topic = topic;
    [newQuestion addMessage:[Message messageWithText:question owner:owner inQuestion:newQuestion atDate:[NSDate date]]];
    [newQuestion setCoordinate:owner.coordinate];
    newQuestion.isSolved = NO;
    
    return newQuestion;
}
@end