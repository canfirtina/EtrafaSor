//
//  SignUpViewController.m
//  EtrafaSor
//
//  Created by Can Firtina on 25/01/14.
//  Copyright (c) 2014 Can Firtina. All rights reserved.
//

#import "SignUpViewController.h"
#import "EtrafaSorHTTPRequestHandler.h"
#import "AppDelegate.h"

#define DEFAULT_IMAGE_URL @"http://canfirtina.com/projectTrials/profile.jpg"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

@synthesize emailField = _emailField;
@synthesize userNameField = _userNameField;
@synthesize passwordField = _passwordField;
@synthesize signUpButton = _signUpButton;

#pragma mark - System
- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.userNameField.delegate = self;
    self.passwordField.delegate = self;
    self.emailField.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

#pragma mark - Actions
- (IBAction)signUpPressed:(UIButton *)sender {
    
    [self dismissKeyboard];
    
    Profile *profile = [Profile profileWithUserEMail:self.emailField.text
                                            userName:self.userNameField.text
                                            imageURL:[NSURL URLWithString:DEFAULT_IMAGE_URL]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        BOOL success = [EtrafaSorHTTPRequestHandler signUpUserProfile:profile];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if( success) [self dismissViewControllerAnimated:YES completion:^{
                //do sth with success
            }];
            else NSLog(@"not succeeded sign up");
        });
    });
}

- (void)dismissKeyboard {
    
    [self.userNameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [self.emailField resignFirstResponder];
}

#pragma mark - Delegations
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    if( self.signUpButton.isEnabled && newLength == 0) self.signUpButton.enabled = NO;
    else if( !self.signUpButton.isEnabled && self.emailField.text.length > 0 && self.userNameField.text.length > 0 && self.passwordField.text.length > 0) self.signUpButton.enabled = YES;
    
    return YES;
}

@end
