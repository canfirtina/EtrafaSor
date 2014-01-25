//
//  EtrafaSorHTTPRequestHandler.h
//  EtrafaSor
//
//  Created by Can Firtina on 22/01/14.
//  Copyright (c) 2014 Can Firtina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Message.h"

@interface EtrafaSorHTTPRequestHandler : NSObject

+ (NSArray *)fetchQuestionsAroundCenterCoordinate:(CLLocationCoordinate2D)coordinate
                                       withRadius:(CGFloat)radius;

+ (NSArray *)fetchPeopleAroundCenterCoordinate:(CLLocationCoordinate2D)coordinate
                               withRadius:(CGFloat)radius;

+ (Profile *)fetchProfileWithUserEMail:(NSString *)userEMail
                           andPassword:(NSString *)password;

+ (BOOL)signUpUserProfile:(Profile *)profile;

+ (BOOL)forgotPasswordRequestedForEMailAddress:(NSString *)eMailAddress;

+ (BOOL)updateUserCheckIn:(Profile *)profile inCoordinate:(CLLocationCoordinate2D)coordinate;

+ (BOOL)postQuestion:(Question *)question OfUser:(Profile *)user;

+ (BOOL)postMessage:(Message *)message;
@end
