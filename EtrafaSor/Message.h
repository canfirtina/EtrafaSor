//
//  Message.h
//  EtrafaSor
//
//  Created by Can Firtina on 22/01/14.
//  Copyright (c) 2014 Can Firtina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Profile.h"
#import "Question.h"

@protocol MessageStatusObserver <NSObject>
- (void)updateMessageStatus;
@end

@interface Message : NSObject

@property (strong, nonatomic) NSString *text;
@property (nonatomic) NSUInteger *totalVoteValue;
@property (strong, nonatomic) Profile *owner;
@property (strong, nonatomic) Question *question;
@property (nonatomic) BOOL isSent;

+ (Message *)messageWithText:(NSString *)text owner:(Profile *)owner inQuestion:(Question *)question;

//Observer Pattern
- (void)attachObserverForMessageStatusChange:(id<MessageStatusObserver>)observer;
- (void)dettachObserverForMessageStatusChange:(id<MessageStatusObserver>)observer;
@end
