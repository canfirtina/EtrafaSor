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

+ (void)questionsAroundCenterCoordinate:(CLLocationCoordinate2D)coordinate
                             withRadius:(NSInteger)radius
                                   user:(Profile *)user
                                 sender:(id<EtrafaSorHTTPRequestHandlerDelegate>)sender {
    
    NSString *api = [NSString stringWithFormat:@"api/questions?lat=%f&lng=%f&distance=%d", coordinate.latitude, coordinate.longitude, radius];
    
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
