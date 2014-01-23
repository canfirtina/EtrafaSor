//
//  Question.m
//  EtrafaSor
//
//  Created by Can Firtina on 22/01/14.
//  Copyright (c) 2014 Can Firtina. All rights reserved.
//

#import "Question.h"
#import "Message.h"

@implementation Question

@synthesize coordinate = _coordinate;
@synthesize title = _title;
@synthesize subtitle = _subtitle;
@synthesize messages = _messages;
@synthesize topic = _topic;
@synthesize isSolved = _isSolved;

#pragma mark - Setters & Getters

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate { _coordinate = newCoordinate; }

- (NSString *)title { return self.topic; }

- (NSString *)subtitle { return [self.messages objectAtIndex:0]; }

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
#pragma mark - Allocations

+ (Question *)questionWithTopic:(NSString *)topic questionMessage:(NSString *)question owner:(Profile *)owner {
    
    Question *newQuestion = [[Question alloc] init];
    newQuestion.topic = topic;
    [newQuestion addMessage:[Message messageWithText:question owner:owner inQuestion:newQuestion]];
    
    return newQuestion;
}
@end
