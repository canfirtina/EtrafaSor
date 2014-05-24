//
//  Message.h
//  EtrafaSor
//
//  Created by Can Firtina on 22/01/14.
//  Copyright (c) 2014 Can Firtina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Question.h"

@protocol MessageStatusObserver <NSObject>
@required
- (void)updateMessageStatus;
@end

@interface Message : NSObject

@property (strong, nonatomic) NSString *text;
@property (nonatomic) NSUInteger *totalVoteValue;
@property (strong, nonatomic) Profile *owner;
@property (strong, nonatomic) Question *question;
@property (strong, nonatomic) NSDate *messageSendDate;
@property (nonatomic) BOOL isSent;

+ (Message *)messageWithText:(NSString *)text owner:(Profile *)owner inQuestion:(Question *)question atDate:(NSDate *)date;

//Observer Pattern
- (void)attachObserverForMessageStatusChange:(id<MessageStatusObserver>)observer;
- (void)dettachObserverForMessageStatusChange:(id<MessageStatusObserver>)observer;
@end