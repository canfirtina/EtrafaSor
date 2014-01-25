//
//  EtrafaSorHTTPRequestHandler.m
//  EtrafaSor
//
//  Created by Can Firtina on 22/01/14.
//  Copyright (c) 2014 Can Firtina. All rights reserved.
//

#import "EtrafaSorHTTPRequestHandler.h"
#include <stdlib.h>
#import "AppDelegate.h"

@implementation EtrafaSorHTTPRequestHandler


+ (Question *)createRandomQuestionforProfile:(Profile *)profile {
    
    static int i = 0;
        
    Question *question = [Question questionWithTopic:[NSString stringWithFormat:@"%d %@", i++, profile.userName] questionMessage:@"messageasdnaskjdahsdhkasdh" owner:profile];
    
    return question;
}

+ (NSArray *)createRandomProfilesAroundCoordinate:(CLLocationCoordinate2D)coordinate {
    
    NSMutableArray *profiles = [NSMutableArray array];
    int lenght = arc4random_uniform(40);
    
    for( int i = 1; i < lenght; i++) {
        
        Profile *profile = [Profile profileWithUserEMail:[NSString stringWithFormat:@"%d@gmail.com", i]
                                                userName:[NSString stringWithFormat:@"%dCan", i]
                                                imageURL:[NSURL URLWithString:@"http://canfirtina.com/projectTrials/profile.jpg"]];
        
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
    
    [profiles addObject:[(AppDelegate *)[[UIApplication sharedApplication] delegate] profile]];
    
    return profiles;
}

+ (NSArray *)fetchQuestionsAroundCenterCoordinate:(CLLocationCoordinate2D)coordinate
                                       withRadius:(CGFloat)radius
                                           sender:(id<EtrafaSorHTTPRequestHandlerDelegate>)sender {
    
    NSMutableArray *questionsToSend = [NSMutableArray array];
    
    NSArray *profiles = [EtrafaSorHTTPRequestHandler createRandomProfilesAroundCoordinate:coordinate];
    
    for (Profile *profile in profiles) {
        for (Question *question in profile.questions) {
            if( [[[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude] distanceFromLocation:[[CLLocation alloc] initWithLatitude:question.coordinate.latitude longitude:question.coordinate.longitude]] < radius){
                [questionsToSend addObject:question];
            }
        }
    }
    
    return [questionsToSend copy];
}

+ (void)fetchPeopleAroundCenterCoordinate:(CLLocationCoordinate2D)coordinate
                                    withRadius:(CGFloat)radius
                                        sender:(id<EtrafaSorHTTPRequestHandlerDelegate>)sender {
    
    //NSMutableArray *peopleAround = [NSMutableArray array];
    
    //fetch questions
    
    //return [peopleAround copy];
}

+ (void)fetchProfileWithUserEMail:(NSString *)userEMail
                           andPassword:(NSString *)password
                                sender:(id<EtrafaSorHTTPRequestHandlerDelegate>)sender {
    
    EtrafaSorHTTPRequestResponseManager *manager = [[EtrafaSorHTTPRequestResponseManager alloc] init];
    manager.responseData = nil;
    manager.responseData = [NSMutableData data];
    manager.delegate = sender;
    
    NSString *requestURL = [NSString stringWithFormat:@"http://etrafasor-backend.herokuapp.com/api/signIn?email=%@&password=%@", userEMail, password];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    
    [[NSURLConnection alloc] initWithRequest:request delegate:manager];
}

+ (void)signUpUserProfile:(Profile *)profile
              andPassword:(NSString *)password
                   sender:(id<EtrafaSorHTTPRequestHandlerDelegate>)sender{
    
    EtrafaSorHTTPRequestResponseManager *manager = [[EtrafaSorHTTPRequestResponseManager alloc] init];
    manager.responseData = nil;
    manager.responseData = [NSMutableData data];
    manager.delegate = sender;
    
    NSString *requestURL = [NSString stringWithFormat:@"http://etrafasor-backend.herokuapp.com/api/signUp?userName=%@&email=%@&password=%@", profile.userName, profile.userEMail, password];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    
    [[NSURLConnection alloc] initWithRequest:request delegate:manager];
}

+ (void)forgotPasswordRequestedForEMailAddress:(NSString *)eMailAddress
                                        sender:(id<EtrafaSorHTTPRequestHandlerDelegate>)sender {
    
}

+ (void)updateUserCheckIn:(Profile *)profile
             inCoordinate:(CLLocationCoordinate2D)coordinate
                   sender:(id<EtrafaSorHTTPRequestHandlerDelegate>)sender {
    
}

+ (void)postQuestion:(id)question
              OfUser:(Profile *)user
              sender:(id<EtrafaSorHTTPRequestHandlerDelegate>)sender{
    
}

+ (void)postMessage:(id)message
             sender:(id<EtrafaSorHTTPRequestHandlerDelegate>)sender{
    
}

@end
