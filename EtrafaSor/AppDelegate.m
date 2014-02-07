//
//  AppDelegate.m
//  EtrafaSor
//
//  Created by Can Firtina on 21/01/14.
//  Copyright (c) 2014 Can Firtina. All rights reserved.
//

#import "AppDelegate.h"
#import <Security/Security.h>
#import "MapViewController.h"
#import "EtrafaSorHTTPRequestHandler.h"
#import "LoginViewController.h"
#import "WaitScreenViewController.h"

#define USEREMAIL_KEY @"User EMail"
#define PASSWORD_KEY @"Password"
#define USER_NAME_KEY @"User Name"
#define USER_ID_KEY @"User ID"
#define IMAGEURL_KEY @"Image URL"
#define SESSION_ID_KEY @"Session Id"

#define DEFAULT_IMAGE_URL @"http://canfirtina.com/projectTrials/profile.jpg"
#define KEY_CONTENT @"content"
#define KEY_RESULT @"result"
#define KEY_SESSION_ID @"sessionId"
#define KEY_USER_CARD @"userCard"
#define KEY_USER_CARD_USERNAME @"userName"
#define KEY_USER_CARD_USERID @"userId"

#define RESULT_FOR_SUCCESS @"0"
#define RESULT_FOR_INVALID_CREDENTIALS @"4"

@interface AppDelegate () <EtrafaSorHTTPRequestHandlerDelegate, LoginResultResponser>
@property (nonatomic, strong) UIViewController *rootViewController;
@end

@implementation AppDelegate

@synthesize profile = _profile;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UIStoryboard* storyboard = self.window.rootViewController.storyboard;
    self.rootViewController = self.window.rootViewController;
    
    if( ![[NSUserDefaults standardUserDefaults] valueForKey:USEREMAIL_KEY]){
        
        LoginViewController *loginScreenViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginScreen"];
        loginScreenViewController.loginResponseDelegate = self;
        self.window.rootViewController = loginScreenViewController;
        
    } else {
        
        WaitScreenViewController *waitScreenViewController = [storyboard instantiateViewControllerWithIdentifier:@"WaitScreen"];
        self.window.rootViewController = waitScreenViewController;
        
        [EtrafaSorHTTPRequestHandler loginWithUserEMail:[[NSUserDefaults standardUserDefaults] valueForKey:USEREMAIL_KEY]
                                            andPassword:[[NSUserDefaults standardUserDefaults] valueForKey:PASSWORD_KEY]
                                                 sender:self];
    }
    
    return YES;
}

- (void)loginSucceededWithUserProfile:(Profile *)userProfile
                         forUserEMail:(NSString *)userEMail
                             password:(NSString *)password
                            sessionId:(NSString *)sessionId{
    
    [[NSUserDefaults standardUserDefaults] setValue:userEMail forKey:USEREMAIL_KEY];
    [[NSUserDefaults standardUserDefaults] setValue:sessionId forKey:SESSION_ID_KEY];
    [[NSUserDefaults standardUserDefaults] setValue:password forKey:PASSWORD_KEY];
    
    _profile = userProfile;
    self.window.rootViewController = self.rootViewController;
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
                                                userEmail:[[NSUserDefaults standardUserDefaults] valueForKey:USEREMAIL_KEY]
                                                 userName:userNameString
                                                 imageURL:[NSURL URLWithString:DEFAULT_IMAGE_URL]];
            
            [self loginSucceededWithUserProfile:profile
                                   forUserEMail:[[NSUserDefaults standardUserDefaults] valueForKey:USEREMAIL_KEY]
                                       password:[[NSUserDefaults standardUserDefaults] valueForKey:PASSWORD_KEY]
                                      sessionId:sessionIdString];
            
        } else {
            
            UIStoryboard* storyboard = self.window.rootViewController.storyboard;
            LoginViewController *loginScreenViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginScreen"];
            self.window.rootViewController = loginScreenViewController;
        }
    }
}

- (NSString *)sessionId {
    
    return [[NSUserDefaults standardUserDefaults] valueForKey:SESSION_ID_KEY];
}

@end