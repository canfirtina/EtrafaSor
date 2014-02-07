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

+ (NSString *)sharedSessionId {
    
    return [(AppDelegate *)[[UIApplication sharedApplication] delegate] sessionId];
}

+ (void)loginWithUserEMail:(NSString *)userEMail
               andPassword:(NSString *)password
                    sender:(id<EtrafaSorHTTPRequestHandlerDelegate>)sender {
    
    NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys:userEMail,@"email",password,@"password", nil];
    
    [self requestHTTPFromDefaultServerWithMethod:@"POST"
                                             api:@"api/signIn"
                                        dataInfo:newDatasetInfo
                                          userId:@"<null>"
                                          sender:sender];
}

+ (void)signUpUserProfile:(Profile *)profile
              andPassword:(NSString *)password
                   sender:(id<EtrafaSorHTTPRequestHandlerDelegate>)sender{
    
    NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys:profile.userName,@"userName",profile.userEMail,@"email",password,@"password",nil];
    
    [self requestHTTPFromDefaultServerWithMethod:@"POST"
                                             api:@"api/signUp"
                                        dataInfo:newDatasetInfo
                                          userId:@"<null>"
                                          sender:sender];
}

+ (void)forgotPasswordRequestedForEMailAddress:(NSString *)eMailAddress
                                        sender:(id<EtrafaSorHTTPRequestHandlerDelegate>)sender {
}

//+ (Question *)createRandomQuestionforProfile:(Profile *)profile {
//    
//    static int i = 0;
//        
//    Question *question = [Question questionWithTopic:[NSString stringWithFormat:@"%d %@", i++, profile.userName] questionMessage:@"messageasdnaskjdahsdhkasdh" owner:profile];
//    
//    return question;
//}

//+ (NSArray *)createRandomProfilesAroundCoordinate:(CLLocationCoordinate2D)coordinate {
//    
//    NSMutableArray *profiles = [NSMutableArray array];
//    int lenght = arc4random_uniform(40);
//    
//    for( int i = 1; i < lenght; i++) {
//        
//        Profile *profile = [Profile profileWithUserId:nil
//                                            userEmail:[NSString stringWithFormat:@"%d@gmail.com", i]
//                                                userName:[NSString stringWithFormat:@"%dCan", i]
//                                                imageURL:[NSURL URLWithString:@"http://canfirtina.com/projectTrials/profile.jpg"]];
//        
//        int latInt = arc4random_uniform(4284);
//        CGFloat lat = (float)latInt / 1000000;
//        lat = (coordinate.latitude - 0.002228) + lat;
//        
//        int lonInt = arc4random_uniform(5073);
//        CGFloat lon = (float)lonInt / 1000000;
//        lon = (coordinate.longitude - 0.002555) + lon;
//        
//        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lat, lon);
//        [profile setCoordinate:coordinate];
//        
//        profile.questions = [NSArray arrayWithObject:[EtrafaSorHTTPRequestHandler createRandomQuestionforProfile:profile]];
//        
//        [profiles addObject:profile];
//    }
//    
//    [profiles addObject:[(AppDelegate *)[[UIApplication sharedApplication] delegate] profile]];
//    
//    return profiles;
//}

+ (void)questionsAroundCenterCoordinate:(CLLocationCoordinate2D)coordinate
                             withRadius:(CGFloat)radius
                                   user:(Profile *)user
                                 sender:(id<EtrafaSorHTTPRequestHandlerDelegate>)sender {
    
//    NSMutableArray *questionsToSend = [NSMutableArray array];
    
//    NSArray *profiles = [EtrafaSorHTTPRequestHandler createRandomProfilesAroundCoordinate:coordinate];
//    
//    for (Profile *profile in profiles) {
//        for (Question *question in profile.questions) {
//            if( [[[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude] distanceFromLocation:[[CLLocation alloc] initWithLatitude:question.coordinate.latitude longitude:question.coordinate.longitude]] < radius){
//                [questionsToSend addObject:question];
//            }
//        }
//    }
    
    NSString *api = [NSString stringWithFormat:@"api/questions?lat=%f&lng=%f&distance=%f", coordinate.latitude, coordinate.longitude, radius];
    
    [self requestHTTPFromDefaultServerWithMethod:nil
                                             api:api
                                        dataInfo:nil
                                          userId:user.userId
                                          sender:sender];
}

+ (void)peopleAroundCenterCoordinate:(CLLocationCoordinate2D)coordinate
                          withRadius:(CGFloat)radius
                                user:(Profile *)user
                              sender:(id<EtrafaSorHTTPRequestHandlerDelegate>)sender {}

+ (void)updateUserLocationInCoordinate:(CLLocationCoordinate2D)coordinate
                                  user:(Profile *)user
                                sender:(id<EtrafaSorHTTPRequestHandlerDelegate>)sender {
    
    NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:coordinate.latitude], @"lat",[NSNumber numberWithDouble:coordinate.longitude],@"lng", nil];
    
    [self requestHTTPFromDefaultServerWithMethod:@"POST"
                                             api:@"api/locations"
                                        dataInfo:newDatasetInfo
                                          userId:user.userId
                                          sender:sender];
}

+ (void)postQuestion:(Question *)question
                user:(Profile *)user
              sender:(id<EtrafaSorHTTPRequestHandlerDelegate>)sender {
    
    NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:question.coordinate.latitude], @"lat",[NSNumber numberWithDouble:question.coordinate.longitude],@"lng",question.title,@"title",((Message *)question.messages.firstObject).text,@"question", nil];
        
    [self requestHTTPFromDefaultServerWithMethod:@"POST"
                                             api:@"api/questions"
                                        dataInfo:newDatasetInfo
                                          userId:user.userId
                                          sender:sender];
}

+ (void)postMessage:(Message *)message
        forQuestion:(Question *)question
               user:(Profile *)user
             sender:(id<EtrafaSorHTTPRequestHandlerDelegate>)sender {}

+ (void)requestHTTPFromDefaultServerWithMethod:(NSString *)method
                                           api:(NSString *)api
                                      dataInfo:(NSDictionary *)dataSetInfo
                                        userId:(NSString *)userId
                                        sender:(id<EtrafaSorHTTPRequestHandlerDelegate>)sender {

    //initialise manager and data to handle connection
    EtrafaSorHTTPRequestResponseManager *manager = [[EtrafaSorHTTPRequestResponseManager alloc] init];
    manager.responseData = nil;
    manager.responseData = [NSMutableData data];
    manager.delegate = sender;
    
    //modify request
    NSString *requestURL = [NSString stringWithFormat:@"http://etrafasor-backend.herokuapp.com/%@",api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    if( method) [request setHTTPMethod:method];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:userId forHTTPHeaderField:@"X-UserId"];
    [request setValue:[self sharedSessionId] forHTTPHeaderField:@"X-SessionId"];
    if( dataSetInfo) [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:dataSetInfo options:kNilOptions error:nil]];
    
    //connect to request
    [[NSURLConnection alloc] initWithRequest:request delegate:manager];
}

@end
