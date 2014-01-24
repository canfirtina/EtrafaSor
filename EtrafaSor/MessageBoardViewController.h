//
//  MessageBoardViewController.h
//  EtrafaSor
//
//  Created by Can Firtina on 23/01/14.
//  Copyright (c) 2014 Can Firtina. All rights reserved.
//

#import "JSMessagesViewController.h"
#import "Question.h"
#import "Profile.h"

@interface MessageBoardViewController : JSMessagesViewController

@property (nonatomic, strong) Question *question;

@end
