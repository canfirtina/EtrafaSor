//
//  EtrafaSorHTTPRequestHandler.h
//  EtrafaSor
//
//  Created by Can Firtina on 22/01/14.
//  Copyright (c) 2014 Can Firtina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "EtrafaSorHTTPRequestResponseManager.h"
#import "Message.h"

@interface EtrafaSorHTTPRequestHandler : NSObject

//if you want to be notified about connection results, set sender

//user information not needed
+ (void)loginWithUserEMail:(NSString *)userEMail
               andPassword:(NSString *)password
                    sender:(id<EtrafaSorHTTPRequestHandlerDelegate>)sender;

+ (void)signUpUserProfile:(Profile *)profile
              andPassword:(NSString *)password
                   sender:(id<EtrafaSorHTTPRequestHandlerDelegate>)sender;

+ (void)forgotPasswordRequestedForEMailAddress:(NSString *)eMailAddress
                                        sender:(id<EtrafaSorHTTPRequestHandlerDelegate>)sender;

+ (void)questionsAroundCenterCoordinate:(CLLocationCoordinate2D)coordinate
                             withRadius:(NSInteger)radius
                                   user:(Profile *)user
                                 sender:(id<EtrafaSorHTTPRequestHandlerDelegate>)sender;

//user information needed
+ (void)peopleAroundCenterCoordinate:(CLLocationCoordinate2D)coordinate
                          withRadius:(CGFloat)radius
                                user:(Profile *)user
                              sender:(id<EtrafaSorHTTPRequestHandlerDelegate>)sender;

+ (void)updateUserLocationInCoordinate:(CLLocationCoordinate2D)coordinate
                                  user:(Profile *)user
                                sender:(id<EtrafaSorHTTPRequestHandlerDelegate>)sender;

+ (void)postQuestion:(Question *)question
                user:(Profile *)user
              sender:(id<EtrafaSorHTTPRequestHandlerDelegate>)sender;

+ (void)postMessage:(Message *)message
        forQuestion:(Question *)question
               user:(Profile *)user
             sender:(id<EtrafaSorHTTPRequestHandlerDelegate>)sender;
@end
