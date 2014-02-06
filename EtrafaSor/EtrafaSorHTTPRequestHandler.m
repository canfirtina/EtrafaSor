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
        
        Profile *profile = [Profile profileWithUserId:nil
                                            userEmail:[NSString stringWithFormat:@"%d@gmail.com", i]
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
}

+ (void)fetchProfileWithUserEMail:(NSString *)userEMail
                           andPassword:(NSString *)password
                                sender:(id<EtrafaSorHTTPRequestHandlerDelegate>)sender {
    
    NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys:userEMail,@"email",password,@"password", nil];
    
    [self requestPostHTTPFromDefaultServer:@"api/signIn" dataInfo:newDatasetInfo userId:@"<null>" sender:sender];
}

+ (void)signUpUserProfile:(Profile *)profile
              andPassword:(NSString *)password
                   sender:(id<EtrafaSorHTTPRequestHandlerDelegate>)sender{
    
    NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys:profile.userName,@"userName",profile.userEMail,@"email",password,@"password",nil];
    
    [self requestPostHTTPFromDefaultServer:@"api/signUp" dataInfo:newDatasetInfo userId:@"<null>" sender:sender];
}

+ (void)forgotPasswordRequestedForEMailAddress:(NSString *)eMailAddress
                                        sender:(id<EtrafaSorHTTPRequestHandlerDelegate>)sender {
}

+ (void)updateUserCheckIn:(Profile *)profile
             inCoordinate:(CLLocationCoordinate2D)coordinate
                   sender:(id<EtrafaSorHTTPRequestHandlerDelegate>)sender {
    
    NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:coordinate.latitude], @"lat",[NSNumber numberWithFloat:coordinate.longitude],@"lng", nil];
    
    [self requestPostHTTPFromDefaultServer:@"api/locations" dataInfo:newDatasetInfo userId:profile.userId sender:sender];
}

+ (void)postQuestion:(Question *)question
              OfUser:(Profile *)user
              sender:(id<EtrafaSorHTTPRequestHandlerDelegate>)sender{
    
    NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:question.coordinate.latitude], @"lat",[NSNumber numberWithFloat:question.coordinate.longitude],@"lng",question.title,@"title",((Message *)question.messages.firstObject).text,@"question", nil];
    
    NSLog(@"%@", newDatasetInfo);
    
    [self requestPostHTTPFromDefaultServer:@"api/questions" dataInfo:newDatasetInfo userId:user.userId sender:sender];
}

+ (void)postMessage:(Message *)message
        forQuestion:(Question *)question
             sender:(id<EtrafaSorHTTPRequestHandlerDelegate>)sender{
}

+ (void)requestPostHTTPFromDefaultServer:(NSString *)api dataInfo:(NSDictionary *)dataSetInfo userId:(NSString *)userId sender:(id<EtrafaSorHTTPRequestHandlerDelegate>)sender {
    
    NSError*error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dataSetInfo options:kNilOptions error:&error];
    
    NSString *sessionId = [(AppDelegate *)[[UIApplication sharedApplication] delegate] sessionId];
    
    EtrafaSorHTTPRequestResponseManager *manager = [[EtrafaSorHTTPRequestResponseManager alloc] init];
    manager.responseData = nil;
    manager.responseData = [NSMutableData data];
    manager.delegate = sender;
    
    NSString *requestURL = [NSString stringWithFormat:@"http://etrafasor-backend.herokuapp.com/%@",api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:userId forHTTPHeaderField:@"X-UserId"];
    [request setValue:sessionId forHTTPHeaderField:@"X-SessionId"];
    [request setHTTPBody:jsonData];
    
    [[NSURLConnection alloc] initWithRequest:request delegate:manager];
}

@end
