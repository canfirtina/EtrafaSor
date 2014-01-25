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

@interface MessageBoardViewController ()
@property (nonatomic, strong) Profile *userProfile;
@end

@implementation MessageBoardViewController

@synthesize userProfile = _userProfile;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[JSBubbleView appearance] setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
    
    self.userProfile = [(AppDelegate *)[[UIApplication sharedApplication] delegate] profile];
    self.delegate = self;
    self.dataSource = self;
    
    self.title = self.question.title;
    self.messageInputView.textView.placeHolder = @"Write Answer";
    self.sender = self.userProfile.userName;
}

#pragma mark - UITableViewDataSource Responses

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.question.messages.count;
}

#pragma mark - JSMessageViewDelegate Responses

- (void)didSendMessage:(JSMessage *)message {
    
    [self.question postMessage:message.text forUser:self.userProfile usingBlock:^(BOOL succeeded) {
        
        if( !succeeded) NSLog(@"message sent not success");
        else NSLog(@"message sent success");
    }];
    
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

//- (void)configureCell:(JSBubbleMessageCell *)cell atIndexPath:(NSIndexPath *)indexPath {}

- (BOOL)shouldPreventScrollToBottomWhileUserScrolling { return NO; }

- (BOOL)allowsPanToDismissKeyboard { return YES; }

//- (UIButton *)sendButtonForInputView;

/**
 *  Asks the delegate for a custom cell reuse identifier for the row to be displayed at the specified index path.
 *
 *  @param indexPath The index path of the row to be displayed.
 *
 *  @return A string specifying the cell reuse identifier for the row at indexPath.
 */
- (NSString *)customCellIdentifierForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Message *message = [self.question.messages objectAtIndex:indexPath.row];
    
    return [NSString stringWithFormat:@"%@ - %@", message.text, message.owner.userName];
}

#pragma mark - JSMessageViewDataSource Responses

/**
 *  Asks the data source for the message to display for the row at the specified index path. The message text is displayed in the bubble at index path. The message date is displayed *above* the row at the specified index path. The message sender is displayed *below* the row at the specified index path.
 *
 *  @param indexPath An index path locating a row in the table view.
 *
 *  @return A message object containing the message data. This value must not be `nil`.
 */
- (JSMessage *)messageForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Message *message = [self.question.messages objectAtIndex:indexPath.row];
    
    JSMessage *jsmessage = [[JSMessage alloc] initWithText:message.text
                                                    sender:message.owner.userName
                                                      date:message.messageSendDate];
    
    return jsmessage;
}

/**
 *  Asks the data source for the imageView to display for the row at the specified index path with the given sender. The imageView must have its `image` property set.
 *
 *  @param indexPath An index path locating a row in the table view.
 *  @param sender    The name of the user who sent the message at indexPath.
 *
 *  @return An image view specifying the avatar for the message at indexPath. This value may be `nil`.
 */
- (UIImageView *)avatarImageViewForRowAtIndexPath:(NSIndexPath *)indexPath sender:(NSString *)sender {
    
    Message *message = [self.question.messages objectAtIndex:indexPath.row];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:message.owner.userImageURL]]];
    //imageView.frame = CGRectMake(0,0,32,32);
    
    return imageView;
}

@end
