//
//  EtrafaSorHTTPRequestHandler.m
//  EtrafaSor
//
//  Created by Can Firtina on 22/01/14.
//  Copyright (c) 2014 Can Firtina. All rights reserved.
//

#import "EtrafaSorHTTPRequestHandler.h"

@implementation EtrafaSorHTTPRequestHandler


+ (NSArray *)fetchQuestionsAroundCenterCoordinate:(CLLocationCoordinate2D)coordinate
                                       withRadius:(CGFloat)radius {
    
    NSMutableArray *questions = [NSMutableArray array];
    
    //fetch questions
    
    return [questions copy];
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

@end
