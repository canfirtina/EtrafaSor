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

#define USEREMAIL_KEY @"User EMail"
#define PASSWORD_KEY @"Password"

@interface AppDelegate ()
@property (nonatomic, strong) UIViewController *rootViewController;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if( ![[NSUserDefaults standardUserDefaults] valueForKey:USEREMAIL_KEY]){
        self.rootViewController = self.window.rootViewController;
        
        UIStoryboard* storyboard = self.window.rootViewController.storyboard;
        UIViewController *loginScreenViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginScreen"];
        
        self.window.rootViewController = loginScreenViewController;
    } else {
        
        self.profile = [EtrafaSorHTTPRequestHandler fetchProfileWithUserEMail:[[NSUserDefaults standardUserDefaults] valueForKey:USEREMAIL_KEY]
                                                                  andPassword:[[NSUserDefaults standardUserDefaults] valueForKey:PASSWORD_KEY]];
    }
    
    return YES;
}

- (void)loginSucceededWithUserProfile:(Profile *)userProfile
                         forUserEMail:(NSString *)userEMail
                          andPassword:(NSString *)password
{
    [[NSUserDefaults standardUserDefaults] setValue:userEMail forKey:USEREMAIL_KEY];
    [[NSUserDefaults standardUserDefaults] setValue:password forKey:PASSWORD_KEY];
    
    self.profile = userProfile;
    self.window.rootViewController = self.rootViewController;
}

@end