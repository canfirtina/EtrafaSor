//
//  Question.m
//  EtrafaSor
//
//  Created by Can Firtina on 22/01/14.
//  Copyright (c) 2014 Can Firtina. All rights reserved.
//

#import "Question.h"
#import "EtrafaSorHTTPRequestHandler.h"
#import "AppDelegate.h"

@interface Question () <EtrafaSorHTTPRequestHandlerDelegate>
@property (strong, nonatomic) NSMutableArray *questionContentObservers;
@property (nonatomic, readonly, copy) Profile *userProfile;
@end

@implementation Question

@synthesize coordinate = _coordinate;
@synthesize title = _title;
@synthesize subtitle = _subtitle;
@synthesize messages = _messages;
@synthesize topic = _topic;
@synthesize isSolved = _isSolved;
@synthesize owner = _owner;
@synthesize questionContentObservers = _questionContentObservers;
@synthesize questionId = _questionId;
@synthesize userProfile = _userProfile;

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
        
        [EtrafaSorHTTPRequestHandler answersForQuestion:self user:self.userProfile sender:self];
    }
    
    return _messages;
}

- (Profile *)userProfile {
    
    return [(AppDelegate *)[[UIApplication sharedApplication] delegate] profile];;
}

- (Profile *)owner {
    
    Message *firstMessage = ((Message *)[self.messages firstObject]);
    
    return firstMessage.owner;
}

- (NSMutableArray *)questionContentObservers {
    
    if( !_questionContentObservers) _questionContentObservers = [NSMutableArray array];
    
    return _questionContentObservers;
}

#pragma mark - Property Change

- (void)addMessages:(NSArray *)messages {
    
    NSMutableArray *mutableCopy = [self.messages mutableCopy];
    BOOL didChange = false;
    
    for( Message *message in messages)
        if( ![self.messages containsObject:message]){
            [mutableCopy addObject:message];
            didChange = true;
        }
    
    if( didChange) {
        _messages = [mutableCopy copy];
        [self notifyContentObservers];
    }
}

- (void)addMessage:(Message *)message {
    
    if( ![self.messages containsObject:message]){
        NSMutableArray *mutableCopy = [self.messages mutableCopy];
        [mutableCopy addObject:message];
        _messages = [mutableCopy copy];
        [self notifyContentObservers];
    }
}

- (void)postMessage:(NSString *)text forUser:(Profile *)user {
    
    Message *message = [Message messageWithText:text owner:user inQuestion:self atDate:[NSDate date]];
    [self addMessage:message];
    
    [EtrafaSorHTTPRequestHandler postMessage:message
                                 forQuestion:self
                                        user:user
                                      sender:self];
}

#pragma mark - Custom Notification for Profile

- (void)attachObserverForContentChange:(id<QuestionContentObserver>)observer;{
    
    [self.questionContentObservers addObject:observer];
}
- (void)dettachObserverForContentChange:(id<QuestionContentObserver>)observer;{
    
    if( [self.questionContentObservers containsObject:observer])
        [self.questionContentObservers removeObject:observer];
}
- (void)notifyContentObservers{
    
    for (id<QuestionContentObserver> observer in self.questionContentObservers) {
        [observer updateQuestionContent];
    }
}

#pragma mark - Delegations

- (void)connectionHasFinishedWithData:(NSDictionary *)data {
    
    if( !data) NSLog(@"something wrong with questiin");
    else {
        
        NSLog(@"Question");
        for(id key in data) {
            id value = [data objectForKey:key];
            
            NSString *keyAsString = (NSString *)key;
            NSString *valueAsString = (NSString *)value;
            
            NSLog(@"key: %@", keyAsString);
            NSLog(@"value: %@", valueAsString);
        }
    }
}

#pragma mark - Allocations

+ (Question *)questionWithTopic:(NSString *)topic
                questionMessage:(NSString *)question
                     questionId:(NSString *)questionId
                     coordinate:(CLLocationCoordinate2D)coordinate
                          owner:(Profile *)owner {
    
    Question *newQuestion = [[Question alloc] init];
    newQuestion.topic = topic;
    [newQuestion addMessage:[Message messageWithText:question owner:owner inQuestion:newQuestion atDate:[NSDate date]]];
    [newQuestion setCoordinate:coordinate];
    newQuestion.questionId = questionId;
    newQuestion.isSolved = NO;
    
    return newQuestion;
}
@end