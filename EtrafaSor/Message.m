//
//  Message.m
//  EtrafaSor
//
//  Created by Can Firtina on 22/01/14.
//  Copyright (c) 2014 Can Firtina. All rights reserved.
//

#import "Message.h"

@implementation Message

@synthesize text = _text;
@synthesize totalVoteValue = _totalVoteValue;
@synthesize owner = _owner;
@synthesize question = _question;

+ (Message *)messageWithText:(NSString *)text owner:(Profile *)owner inQuestion:(Question *)question {
    
    Message *newMessage = [[Message alloc] init];
    newMessage.text = text;
    newMessage.totalVoteValue = 0;
    newMessage.owner = owner;
    newMessage.question = question;
    
    return newMessage;
}

@end
