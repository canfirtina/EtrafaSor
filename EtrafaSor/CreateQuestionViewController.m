//
//  CreateQuestionViewController.m
//  EtrafaSor
//
//  Created by Can Firtina on 23/01/14.
//  Copyright (c) 2014 Can Firtina. All rights reserved.
//

#import "CreateQuestionViewController.h"

@interface CreateQuestionViewController ()

@end

@implementation CreateQuestionViewController

#pragma mark - System
- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.questionTopicField.delegate = self;
    self.questionDetailed.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard {
    
    [self.questionTopicField resignFirstResponder];
    [self.questionDetailed resignFirstResponder];
}

#pragma mark - Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
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
@end
