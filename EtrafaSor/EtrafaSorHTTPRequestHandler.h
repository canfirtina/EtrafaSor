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
+ (NSArray *)fetchQuestionsAroundCenterCoordinate:(CLLocationCoordinate2D)coordinate
                                       withRadius:(CGFloat)radius
                                           sender:(id<EtrafaSorHTTPRequestHandlerDelegate>)sender;

+ (void)peopleAroundCenterCoordinate:(CLLocationCoordinate2D)coordinate
                               withRadius:(CGFloat)radius
                                        sender:(id<EtrafaSorHTTPRequestHandlerDelegate>)sender;

+ (void)loginWithUserEMail:(NSString *)userEMail
                           andPassword:(NSString *)password
                                sender:(id<EtrafaSorHTTPRequestHandlerDelegate>)sender;

+ (void)signUpUserProfile:(Profile *)profile
              andPassword:(NSString *)password
                   sender:(id<EtrafaSorHTTPRequestHandlerDelegate>)sender;

+ (void)forgotPasswordRequestedForEMailAddress:(NSString *)eMailAddress
                                        sender:(id<EtrafaSorHTTPRequestHandlerDelegate>)sender;

+ (void)updateUserCheckIn:(Profile *)profile
             inCoordinate:(CLLocationCoordinate2D)coordinate
                   sender:(id<EtrafaSorHTTPRequestHandlerDelegate>)sender;

+ (void)postQuestion:(Question *)question
              OfUser:(Profile *)user
              sender:(id<EtrafaSorHTTPRequestHandlerDelegate>)sender;

+ (void)postMessage:(Message *)message
        forQuestion:(Question *)question
             sender:(id<EtrafaSorHTTPRequestHandlerDelegate>)sender;
@end
