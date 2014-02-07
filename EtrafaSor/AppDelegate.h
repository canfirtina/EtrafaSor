//
//  AppDelegate.h
//  EtrafaSor
//
//  Created by Can Firtina on 21/01/14.
//  Copyright (c) 2014 Can Firtina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Profile.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic, readonly) Profile *profile;
@property (nonatomic, readonly, copy) NSString *sessionId;

- (void)loginSucceededWithUserProfile:(Profile *)userProfile
                         forUserEMail:(NSString *)userEMail
                             password:(NSString *)password
                            sessionId:(NSString *)sessionId;
@end
