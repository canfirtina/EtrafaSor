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

/**
 *  Tells the delegate that the specified message has been sent.
 *
 *  @param message A message object containing:
 *      1. text: the text that was present in the textView of the messageInputView when the send button was pressed.
 *      2. date: the current date
 *      3. sender: the value of sender
 */
- (void)didSendMessage:(JSMessage *)message {
    
    [self.question postMessage:message.text forUser:self.userProfile usingBlock:^(BOOL succeeded) {
        
        if( !succeeded) NSLog(@"message sent not success");
        else NSLog(@"message sent success");
    }];
}

/**
 *  Asks the delegate for the message type for the row at the specified index path.
 *
 *  @param indexPath The index path of the row to be displayed.
 *
 *  @return A constant describing the message type.
 *  @see JSBubbleMessageType.
 */
- (JSBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Message *message = [self.question.messages objectAtIndex:indexPath.row];
    
    if( [message.owner.userName isEqualToString:self.userProfile.userName]){
        
        return JSBubbleMessageTypeOutgoing;
    }
    
    return JSBubbleMessageTypeIncoming;
}

/**
 *  Asks the delegate for the bubble image view for the row at the specified index path with the specified type.
 *
 *  @param type      The type of message for the row located at indexPath.
 *  @param indexPath The index path of the row to be displayed.
 *
 *  @return A `UIImageView` with both `image` and `highlightedImage` properties set.
 *  @see JSBubbleImageViewFactory.
 */
- (UIImageView *)bubbleImageViewWithType:(JSBubbleMessageType)type
                       forRowAtIndexPath:(NSIndexPath *)indexPath {
    Message *message = [self.question.messages objectAtIndex:indexPath.row];
    
    if ( [message.owner.userName isEqualToString:self.userProfile.userName]) {
        return [JSBubbleImageViewFactory bubbleImageViewForType:type
                                                          color:[UIColor js_bubbleLightGrayColor]];
    }
    
    return [JSBubbleImageViewFactory bubbleImageViewForType:type
                                                      color:[UIColor js_bubbleBlueColor]];
}

/**
 *  Asks the delegate for the input view style.
 *
 *  @return A constant describing the input view style.
 *  @see JSMessageInputViewStyle.
 */
- (JSMessageInputViewStyle)inputViewStyle {
    
    return JSMessageInputViewStyleFlat;
}

- (BOOL)shouldDisplayTimestampForRowAtIndexPath:(NSIndexPath *)indexPath { return YES; }

/**
 *  Asks the delegate to configure or further customize the given cell at the specified index path.
 *
 *  @param cell      The message cell to configure.
 *  @param indexPath The index path for cell.
 */
//- (void)configureCell:(JSBubbleMessageCell *)cell atIndexPath:(NSIndexPath *)indexPath {}

/**
 *  Asks the delegate if should always scroll to bottom automatically when new messages are sent or received.
 *
 *  @return `YES` if you would like to prevent the table view from being scrolled to the bottom while the user is scrolling the table view manually, `NO` otherwise.
 */
- (BOOL)shouldPreventScrollToBottomWhileUserScrolling { return NO; }

/**
 *  Ask the delegate if the keyboard should be dismissed by panning/swiping downward. The default value is `YES`. Return `NO` to dismiss the keyboard by tapping.
 *
 *  @return A boolean value specifying whether the keyboard should be dismissed by panning/swiping.
 */
- (BOOL)allowsPanToDismissKeyboard { return YES; }

/**
 *  Asks the delegate for the send button to be used in messageInputView. Implement this method if you wish to use a custom send button. The button must be a `UIButton` or a subclass of `UIButton`. The button's frame is set for you.
 *
 *  @return A custom `UIButton` to use in messageInputView.
 */
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
