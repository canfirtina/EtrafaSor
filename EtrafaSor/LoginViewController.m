//
//  LoginViewController.m
//  EtrafaSor
//
//  Created by Can Firtina on 21/01/14.
//  Copyright (c) 2014 Can Firtina. All rights reserved.
//

#import "LoginViewController.h"
#import "Profile.h"

#define DEFAULT_IMAGE_URL @"http://canfirtina.com/projectTrials/profile.jpg"
#define KEY_CONTENT @"content"
#define KEY_RESULT @"result"
#define KEY_SESSION_ID @"sessionId"
#define KEY_USER_CARD @"userCard"
#define KEY_USER_CARD_USERNAME @"userName"
#define KEY_USER_CARD_USERID @"userId"

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
    
    [EtrafaSorHTTPRequestHandler loginWithUserEMail:self.userEmailField.text
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
        NSString *userIdString;
        NSString *sessionIdString;
        
        BOOL succeded = NO;
        
        for(id key in data) {
            id value = [data objectForKey:key];
                        
            NSString *keyAsString = (NSString *)key;
            NSString *valueAsString = (NSString *)value;
            
            if( [keyAsString isEqualToString:KEY_CONTENT]){
                
                id sessionID = [value objectForKey:KEY_SESSION_ID]; //string
                id userCard = [value objectForKey:KEY_USER_CARD]; //dictionary
                id userName = [userCard objectForKey:KEY_USER_CARD_USERNAME]; //string
                id userId = [userCard objectForKey:KEY_USER_CARD_USERID]; //string
                userNameString = [NSString stringWithFormat:@"%@", userName];
                userIdString = [NSString stringWithFormat:@"%@", userId];
                sessionIdString = [NSString stringWithFormat:@"%@", sessionID];
                
            } else if( [keyAsString isEqualToString:KEY_RESULT]){
                
                if( [[NSString stringWithFormat:@"%@", valueAsString] isEqualToString:RESULT_FOR_SUCCESS])
                    succeded = YES;
            }
        }
        
        if( succeded){
            
            Profile *profile = [Profile profileWithUserId:userIdString
                                                userEmail:self.userEmailField.text
                                                    userName:userNameString
                                                    imageURL:[NSURL URLWithString:DEFAULT_IMAGE_URL]];
            
            [self.loginResponseDelegate loginSucceededWithUserProfile:profile
                                                         forUserEMail:self.userEmailField.text
                                                             password:self.passwordField.text
                                                            sessionId:sessionIdString];
        } else NSLog(@"login not succeded");
        
        [self enableAllButtons:YES];
    }
}

#pragma mark - Segue Actions

- (IBAction)dismissByCancelToLoginViewController:(UIStoryboardSegue *)segue {}
@end
