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

#define USEREMAIL_KEY @"User EMail"
#define PASSWORD_KEY @"Password"
#define USER_NAME_KEY @"User Name"
#define USER_ID_KEY @"User ID"
#define IMAGEURL_KEY @"Image URL"
#define SESSION_ID_KEY @"Session Id"

#define DEFAULT_IMAGE_URL @"http://canfirtina.com/projectTrials/profile.jpg"
#define KEY_FOR_CONTENT @"content"
#define KEY_FOR_RESULT @"result"
#define KEY_FOR_CONTENT_SESSION_ID @"sessionId"
#define KEY_FOR_CONTENT_USER_CARD @"userCard"
#define KEY_FOR_CONTENT_USER_CARD_USERNAME @"userName"
#define RESULT_FOR_SUCCESS @"0"
#define RESULT_FOR_INVALID_CREDENTIALS @"4"

@interface AppDelegate () <EtrafaSorHTTPRequestHandlerDelegate>
@property (nonatomic, strong) UIViewController *rootViewController;
@end

@implementation AppDelegate

@synthesize profile = _profile;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UIStoryboard* storyboard = self.window.rootViewController.storyboard;
    LoginViewController *loginScreenViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginScreen"];
    
    if( ![[NSUserDefaults standardUserDefaults] valueForKey:USEREMAIL_KEY]){
        self.rootViewController = self.window.rootViewController;
        
        self.window.rootViewController = loginScreenViewController;
    } else {
        
        //[EtrafaSorHTTPRequestHandler fetchProfileWithUserEMail:[[NSUserDefaults standardUserDefaults] valueForKey:USEREMAIL_KEY]
          //                                                    andPassword:[[NSUserDefaults standardUserDefaults] valueForKey:PASSWORD_KEY]
            //                                                       sender:loginScreenViewController];
        
        NSString *userEmail = [[NSUserDefaults standardUserDefaults] valueForKey:USEREMAIL_KEY];
        NSString *userName = [[NSUserDefaults standardUserDefaults] valueForKey:USER_NAME_KEY];
        NSString *userId = [[NSUserDefaults standardUserDefaults] valueForKey:USER_ID_KEY];
        NSString *imageURLString = [[NSUserDefaults standardUserDefaults] valueForKey:IMAGEURL_KEY];
        self.sessionId = [[NSUserDefaults standardUserDefaults] valueForKey:SESSION_ID_KEY];
        
        NSURL *imageURL = [NSURL URLWithString:imageURLString];
        
        _profile = [Profile profileWithUserId:userId
                                    userEmail:userEmail
                                     userName:userName
                                     imageURL:imageURL];
    }
    
    return YES;
}

- (void)loginSucceededWithUserProfile:(Profile *)userProfile
                         forUserEMail:(NSString *)userEMail
                          password:(NSString *)password
                            sessionId:(NSString *)sessionId{
    
    [[NSUserDefaults standardUserDefaults] setValue:userEMail forKey:USEREMAIL_KEY];
    [[NSUserDefaults standardUserDefaults] setValue:userProfile.userName forKey:USER_NAME_KEY];
    [[NSUserDefaults standardUserDefaults] setValue:userProfile.userImageURL.relativeString forKey:IMAGEURL_KEY];
    [[NSUserDefaults standardUserDefaults] setValue:userProfile.userId forKey:USER_ID_KEY];
    [[NSUserDefaults standardUserDefaults] setValue:sessionId forKey:SESSION_ID_KEY];
    
    self.sessionId = sessionId;
    
    _profile = userProfile;
    self.window.rootViewController = self.rootViewController;
}

- (void)connectionHasFinishedWithData:(NSDictionary *)data {
    
}

@end