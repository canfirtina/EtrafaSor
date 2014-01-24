//
//  EtrafaSorHTTPRequestHandler.m
//  EtrafaSor
//
//  Created by Can Firtina on 22/01/14.
//  Copyright (c) 2014 Can Firtina. All rights reserved.
//

#import "EtrafaSorHTTPRequestHandler.h"
#include <stdlib.h>

@implementation EtrafaSorHTTPRequestHandler


+ (Question *)createRandomQuestionforProfile:(Profile *)profile {
    
    static int i = 0;
        
    Question *question = [Question questionWithTopic:[NSString stringWithFormat:@"%d %@", i++, profile.userName] questionMessage:@"message" owner:profile];
    
    return question;
}

+ (NSArray *)createRandomProfilesAroundCoordinate:(CLLocationCoordinate2D)coordinate {
    
    NSMutableArray *profiles = [NSMutableArray array];
    int lenght = arc4random_uniform(40);
    for( int i = 1; i < lenght; i++) {
        
        Profile *profile = [Profile profileWithUserEMail:[NSString stringWithFormat:@"%d@gmail.com", i] userName:[NSString stringWithFormat:@"%dCan", i]];
        profile.userImageURL = [NSURL URLWithString:@"http://canfirtina.com/projectTrials/profile.jpg"];
        
        int latInt = arc4random_uniform(4284);
        CGFloat lat = (float)latInt / 1000000;
        lat = (coordinate.latitude - 0.002228) + lat;
        
        int lonInt = arc4random_uniform(5073);
        CGFloat lon = (float)lonInt / 1000000;
        lon = (coordinate.longitude - 0.002555) + lon;
        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lat, lon);
        [profile setCoordinate:coordinate];
        
        profile.questions = [NSArray arrayWithObject:[EtrafaSorHTTPRequestHandler createRandomQuestionforProfile:profile]];
        
        [profiles addObject:profile];
    }
    
    return profiles;
}

+ (NSArray *)fetchQuestionsAroundCenterCoordinate:(CLLocationCoordinate2D)coordinate
                                       withRadius:(CGFloat)radius {
    
    NSMutableArray *questionsToSend = [NSMutableArray array];
    
    NSArray *profiles = [EtrafaSorHTTPRequestHandler createRandomProfilesAroundCoordinate:coordinate];
    
    for (Profile *profile in profiles) {
        for (Question *question in profile.questions) {
            if( [[[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude] distanceFromLocation:[[CLLocation alloc] initWithLatitude:question.coordinate.latitude longitude:question.coordinate.longitude]] < radius){
                NSLog(@"yes");
                [questionsToSend addObject:question];
            }
        }
    }
    
    return [questionsToSend copy];
}

+ (NSArray *)fetchPeopleAroundCenterCoordinate:(CLLocationCoordinate2D)coordinate
                                    withRadius:(CGFloat)radius {
    
    NSMutableArray *peopleAround = [NSMutableArray array];
    
    //fetch questions
    
    return [peopleAround copy];
}

+ (Profile *)fetchProfileWithUserEMail:(NSString *)userEMail
                           andPassword:(NSString *)password{
    
    //trial
    if( [userEMail isEqualToString:@"root"] && [password isEqualToString:@"abc"]){
        
        Profile *userProfile = [Profile profileWithUserEMail:userEMail userName:@"Can"];
        userProfile.userImageURL = [NSURL URLWithString:@"http://canfirtina.com/projectTrials/profile.jpg"];
        
        return userProfile;
    }
    
    return nil;
}

+ (BOOL)signUpUserProfile:(Profile *)profile{
    
    return NO;
}

+ (BOOL)forgotPasswordRequestedForEMailAddress:(NSString *)eMailAddress{
    
    return NO;
}

+ (BOOL)updateUserCheckIn:(NSString *)userEMail inCoordinate:(CLLocationCoordinate2D)coordinate{
    
    return NO;
}

+ (BOOL)postQuestion:(id)question OfUser:(NSString *)userEMail inCoordinate:(CLLocationCoordinate2D)coordinate{
    
    return NO;
}

+ (BOOL)postMessage:(id)message forQuestion:(id)question{
    
    return NO;
}

@end
