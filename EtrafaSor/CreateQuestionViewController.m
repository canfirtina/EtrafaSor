//
//  CreateQuestionViewController.m
//  EtrafaSor
//
//  Created by Can Firtina on 23/01/14.
//  Copyright (c) 2014 Can Firtina. All rights reserved.
//

#import "CreateQuestionViewController.h"
#import "AppDelegate.h"

@interface CreateQuestionViewController ()

@end

@implementation CreateQuestionViewController

@synthesize questionDetailed = _questionDetailed;
@synthesize questionTopicField = _questionTopicField;
@synthesize sendMessageButton = _sendMessageButton;

#pragma mark - System
- (void)viewDidLoad {
    
    [super viewDidLoad];
	
    self.questionTopicField.delegate = self;
    self.questionDetailed.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

#pragma mark - Gesture
-(void)dismissKeyboard {
    
    [self.questionTopicField resignFirstResponder];
    [self.questionDetailed resignFirstResponder];
}

#pragma mark - Actions

- (IBAction)sendMessagePressed:(UIBarButtonItem *)sender {
    
    Profile *questionOwner = [(AppDelegate *)[[UIApplication sharedApplication] delegate] profile];
    Question *question = [Question questionWithTopic:self.questionTopicField.text questionMessage:self.questionDetailed.text owner:questionOwner];
    
    //do it in another thread
    if ( ![EtrafaSorHTTPRequestHandler postQuestion:question OfUser:questionOwner]){
        
        //show unsuccessful posting question message
    }
}

#pragma mark - Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    if( self.sendMessageButton.isEnabled && newLength == 0) self.sendMessageButton.enabled = NO;
    else if( !self.sendMessageButton.isEnabled && newLength > 0 && self.questionDetailed.text.length > 0) self.sendMessageButton.enabled = YES;
    
    return (newLength > 25) ? NO : YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)string {
    
    if( [string isEqualToString:@"\n"]){
        
        [self.questionDetailed resignFirstResponder];
        return NO;
    }
    
    NSUInteger newLength = [textView.text length] + [string length] - range.length;
    return (newLength > 140) ? NO : YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    if( self.sendMessageButton.isEnabled && textView.text.length == 0) self.sendMessageButton.enabled = NO;
    else if( !self.sendMessageButton.isEnabled && textView.text.length > 0 && self.questionTopicField.text.length > 0) self.sendMessageButton.enabled = YES;
}

@end