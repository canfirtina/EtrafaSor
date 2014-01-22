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
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
