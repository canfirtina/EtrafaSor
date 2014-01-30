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

#define DEFAULT_IMAGE_URL @"http://canfirtina.com/projectTrials/profile.jpg"
#define KEY_FOR_CONTENT @"content"
#define KEY_FOR_RESULT @"result"
#define KEY_FOR_CONTENT_SESSION_ID @"sessionId"
#define KEY_FOR_CONTENT_USER_CARD @"userCard"
#define KEY_FOR_CONTENT_USER_CARD_USERNAME @"userName"
#define RESULT_FOR_SUCCESS @"0"
#define RESULT_FOR_INVALID_CREDENTIALS @"4"

@interface LoginViewController () <EtrafaSorHTTPRequestHandlerDelegate>

@end

@implementation LoginViewController

@synthesize userEmailField = _userEmailField;
@synthesize passwordField = _passwordField;
@synthesize loginButton = _loginButton;

#pragma mark - System
- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.userEmailField.delegate = self;
    self.passwordField.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

#pragma mark - Actions
- (IBAction)loginPressed:(UIButton *)sender {
    
    [self dismissKeyboard];
    
    [EtrafaSorHTTPRequestHandler fetchProfileWithUserEMail:self.userEmailField.text
                                               andPassword:self.passwordField.text
                                                    sender:self];
    
    [self enableAllButtons:NO];
}

- (void)dismissKeyboard {
    
    [self.userEmailField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

- (void)enableAllButtons:(BOOL)enabled {
    
    self.loginButton.enabled = enabled;
    self.signUpButton.enabled = enabled;
    self.forgotPasswordButton.enabled = enabled;
}

#pragma mark - Delegations
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

- (void)connectionHasFinishedWithData:(NSDictionary *)data {
    
    if( !data) NSLog(@"login not succeded");
    else {
        
        NSString *userNameString;
        BOOL succeded;
        
        NSLog(@"Login");
        for(id key in data) {
            id value = [data objectForKey:key];
            
            NSString *keyAsString = (NSString *)key;
            NSString *valueAsString = (NSString *)value;
            
            if( [keyAsString isEqualToString:KEY_FOR_CONTENT]){
                
                id sessionID = [value objectForKey:KEY_FOR_CONTENT_SESSION_ID]; //string
                id userCard = [value objectForKey:KEY_FOR_CONTENT_USER_CARD]; //dictionary
                id userName = [userCard objectForKey:KEY_FOR_CONTENT_USER_CARD_USERNAME];
                userNameString = [NSString stringWithFormat:@"%@", userName];
                
            } else if( [keyAsString isEqualToString:KEY_FOR_RESULT]){
                
                if( [[NSString stringWithFormat:@"%@", valueAsString] isEqualToString:RESULT_FOR_SUCCESS])
                    succeded = YES;
                else if ([[NSString stringWithFormat:@"%@", valueAsString] isEqualToString:RESULT_FOR_INVALID_CREDENTIALS])
                    succeded = NO;
            }
        }
        
        if( succeded){
            
            Profile *profile = [Profile profileWithUserEMail:self.userEmailField.text
                                                    userName:[NSString stringWithFormat:@"%@", userNameString]
                                                    imageURL:[NSURL URLWithString:DEFAULT_IMAGE_URL]];
            
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] loginSucceededWithUserProfile:profile
                                                                                          forUserEMail:self.userEmailField.text
                                                                                           andPassword:self.passwordField.text];
            
            [self enableAllButtons:YES];
        } else {
            
            NSLog(@"not succeded");
            [self enableAllButtons:YES];
        }
    }
}

#pragma mark - Segue Actions

- (IBAction)dismissByCancelToLoginViewController:(UIStoryboardSegue *)segue{}
@end
