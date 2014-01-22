//
//  LoginViewController.m
//  EtrafaSor
//
//  Created by Can Firtina on 21/01/14.
//  Copyright (c) 2014 Can Firtina. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"

#define PASSWORD_KEY @"password"
#define USERNAME_KEY @"username"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize usernameField = _usernameField;
@synthesize passwordField = _passwordField;
@synthesize loginButton = _loginButton;

#pragma mark - System
- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.usernameField.delegate = self;
    self.passwordField.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (IBAction)loginPressed:(UIButton *)sender
{
    
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    
    [[NSUserDefaults standardUserDefaults] setValue:self.usernameField.text forKey:USERNAME_KEY];
    [[NSUserDefaults standardUserDefaults] setValue:self.usernameField.text forKey:PASSWORD_KEY];
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] loginSucceeded];
}

-(void)dismissKeyboard {
    
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

#pragma mark - Delegations
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}

@end
