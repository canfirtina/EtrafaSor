//
//  LoginViewController.m
//  EtrafaSor
//
//  Created by Can Firtina on 21/01/14.
//  Copyright (c) 2014 Can Firtina. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "Profile.h"
#import "EtrafaSorHTTPRequestHandler.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize usernameField = _usernameField;
@synthesize passwordField = _passwordField;
@synthesize loginButton = _loginButton;

#pragma mark - System
- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.usernameField.delegate = self;
    self.passwordField.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

#pragma mark - Actions
- (IBAction)loginPressed:(UIButton *)sender {
    
    [self dismissKeyboard];
    
    Profile *profile = [EtrafaSorHTTPRequestHandler fetchProfileWithUserEMail:self.usernameField.text
                                                                  andPassword:self.passwordField.text];
    
    if( profile)
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] loginSucceededWithUserProfile:profile
                                                                                      forUserEMail:self.usernameField.text
                                                                                       andPassword:self.passwordField.text];
    else NSLog(@"Login unsuccessful");
}

- (void)dismissKeyboard {
    
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

#pragma mark - Delegations
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Segue Actions

- (IBAction)dismissByCancelToLoginViewController:(UIStoryboardSegue *)segue{}
@end
