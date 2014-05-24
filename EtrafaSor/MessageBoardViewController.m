//
//  MessageBoardViewController.m
//  EtrafaSor
//
//  Created by Can Firtina on 23/01/14.
//  Copyright (c) 2014 Can Firtina. All rights reserved.
//

#import "MessageBoardViewController.h"
#import "Message.h"
#import "Profile.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"

@interface MessageBoardViewController () <QuestionContentObserver>
@property (nonatomic, readonly, copy) Profile *userProfile;
@property (weak, nonatomic) UIBarButtonItem *cancelButton;
@end

@implementation MessageBoardViewController

@synthesize userProfile = _userProfile;
@synthesize question = _question;

#pragma mark - System
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[JSBubbleView appearance] setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
    
    self.delegate = self;
    self.dataSource = self;
    [self.question attachObserverForContentChange:self];
    
    self.title = self.question.title;
    self.messageInputView.textView.placeHolder = @"Write Answer";
    self.sender = self.userProfile.userName;
}

#pragma mark - Setters & Getters

- (Profile *)userProfile {
    
    return [(AppDelegate *)[[UIApplication sharedApplication] delegate] profile];;
}

#pragma mark - UITableViewDataSource Responses

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.question.messages.count;
}

#pragma mark - JSMessageViewDelegate Responses

- (void)didSendMessage:(JSMessage *)message {
    
    [self.question postMessage:message.text forUser:self.userProfile];
    
    [self finishSend];
    [self scrollToBottomAnimated:YES];
}

- (JSBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Message *message = [self.question.messages objectAtIndex:indexPath.row];
    
    if( [message.owner.userName isEqualToString:self.userProfile.userName]){
        
        return JSBubbleMessageTypeOutgoing;
    }
    
    return JSBubbleMessageTypeIncoming;
}

- (UIImageView *)bubbleImageViewWithType:(JSBubbleMessageType)type
                       forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Message *message = [self.question.messages objectAtIndex:indexPath.row];
    
    if ( [message.owner.userName isEqualToString:self.userProfile.userName]) {
        return [JSBubbleImageViewFactory bubbleImageViewForType:type
                                                          color:[UIColor js_bubbleLightGrayColor]];
    }
    
    return [JSBubbleImageViewFactory bubbleImageViewForType:type
                                                      color:[UIColor js_bubbleGreenColor]];
}

- (JSMessageInputViewStyle)inputViewStyle {
    
    return JSMessageInputViewStyleFlat;
}

- (BOOL)shouldDisplayTimestampForRowAtIndexPath:(NSIndexPath *)indexPath { return YES; }

- (BOOL)shouldPreventScrollToBottomWhileUserScrolling { return NO; }

- (BOOL)allowsPanToDismissKeyboard { return YES; }

//- (UIButton *)sendButtonForInputView;

- (NSString *)customCellIdentifierForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Message *message = [self.question.messages objectAtIndex:indexPath.row];
    
    return (message.owner == self.userProfile)?@"My Message Cell":@"Message Cell";
}

#pragma mark - JSMessageViewDataSource Responses

- (JSMessage *)messageForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Message *message = [self.question.messages objectAtIndex:indexPath.row];
    
    JSMessage *jsmessage = [[JSMessage alloc] initWithText:message.text
                                                    sender:message.owner.userName
                                                      date:message.messageSendDate];
    
    return jsmessage;
}

- (UIImageView *)avatarImageViewForRowAtIndexPath:(NSIndexPath *)indexPath sender:(NSString *)sender {
    
    Message *message = [self.question.messages objectAtIndex:indexPath.row];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setImageWithURL:message.owner.userImageURL placeholderImage:[UIImage imageNamed:@"defaultProfilePicture"]];
    
    return imageView;
}

#pragma mark - Custom Notifications

- (void)updateQuestionContent {
    
    [self.tableView reloadData];
}

@end
