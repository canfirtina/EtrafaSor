//
//  CreateQuestionViewController.m
//  EtrafaSor
//
//  Created by Can Firtina on 23/01/14.
//  Copyright (c) 2014 Can Firtina. All rights reserved.
//

#import "CreateQuestionViewController.h"
#import "AppDelegate.h"

@interface CreateQuestionViewController () <EtrafaSorHTTPRequestHandlerDelegate>

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
    NSMutableArray *mutable = [questionOwner.questions mutableCopy];
    [mutable addObject:question];
    questionOwner.questions = [mutable copy];
                
    //do it in another thread
    [EtrafaSorHTTPRequestHandler postQuestion:question OfUser:questionOwner sender:self];
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

- (void)connectionHasFinishedWithData:(NSDictionary *)data {
    
    if( !data) NSLog(@"something wrong with creation question");
    else {
        
        NSLog(@"Create Question");
        for(id key in data) {
            id value = [data objectForKey:key];
            
            NSString *keyAsString = (NSString *)key;
            NSString *valueAsString = (NSString *)value;
            
            NSLog(@"key: %@", keyAsString);
            NSLog(@"value: %@", valueAsString);
        }
        
        //[self dismissViewControllerAnimated:YES completion:nil]; //if everything is ok then dismiss
    }
}

@end