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

@interface Message : NSObject

@property (strong, nonatomic) NSString *text;
@property (nonatomic) NSUInteger *totalVoteValue;
@property (strong, nonatomic) Profile *owner;
@property (strong, nonatomic) Question *question;

@end
