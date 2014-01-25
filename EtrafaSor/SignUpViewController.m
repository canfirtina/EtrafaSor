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
#define KEY_FOR_RESULT @"result"
#define RESULT_FOR_SUCCESS @"0"

@interface SignUpViewController () <EtrafaSorHTTPRequestHandlerDelegate>

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
    
    [EtrafaSorHTTPRequestHandler signUpUserProfile:profile
                                       andPassword:self.passwordField.text
                                            sender:self];
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

- (void)connectionHasFinishedWithData:(NSDictionary *)data {
    
    if( !data) NSLog(@"failed signup");
    else {
        
        NSLog(@"Sign up");
        for(id key in data) {
            
            id value = [data objectForKey:key];
            
            NSString *keyAsString = (NSString *)key;
            NSString *valueAsString = (NSString *)value;
            
            if( [keyAsString isEqualToString:KEY_FOR_RESULT]){
                
                if( [[NSString stringWithFormat:@"%@", valueAsString] isEqualToString:RESULT_FOR_SUCCESS]) NSLog(@"sign up succeded");
                else NSLog(@"sign up not succeded");
            }
        }
    }
}

@end
