//
//  Profile.m
//  EtrafaSor
//
//  Created by Can Firtina on 22/01/14.
//  Copyright (c) 2014 Can Firtina. All rights reserved.
//

#import "Profile.h"
#import "Message.h"
#import "Question.h"

@interface Profile ()
@property (strong, nonatomic) NSMutableArray *coordinateObservers;
@end

@implementation Profile

@synthesize coordinate = _coordinate;
@synthesize title = _title;
//@synthesize subtitle = _subtitle;
@synthesize userId = _userId;
@synthesize userName = _userName;
@synthesize userEMail = _userEMail;
@synthesize userImageURL = _userImageURL;
@synthesize questions = _questions;
@synthesize answers = _answers;
@synthesize coordinateObservers = _coordinateObservers;

#pragma mark - Custom Allocations

+ (Profile *)profileWithUserId:(NSString *)userId
                         userEmail:(NSString *)userEMail
                      userName:(NSString *)userName
                      imageURL:(NSURL *)imageURL {
    
    Profile *newProfile = [[Profile alloc] init];
    newProfile.userEMail = userEMail;
    newProfile.userName = userName;
    newProfile.userImageURL = imageURL;
    newProfile.userId = userId;
    
    return newProfile;
}

#pragma mark - Setters & Getters

//notification sent there
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    
    _coordinate = newCoordinate;
    [self notifyCoordinateObservers];
}

- (NSString *)title {
    return self.userName;
}

- (NSArray *)questions {
    
    if( !_questions){
        _questions = [NSArray array];
    }
    
    return _questions;
}

- (NSArray *)answers {
    
    if( !_answers){
        _answers = [NSArray array];
    }
    
    return _answers;
}

- (NSMutableArray *)coordinateObservers{
    
    if( !_coordinateObservers) _coordinateObservers = [NSMutableArray array];
    
    return _coordinateObservers;
}

- (void)addAnswer:(Message *)answer {

    
}

- (void)addQuestion:( Question *)question {
    
    
}

#pragma mark - Custom Notification for Profile

- (void)attachObserverForCoordinateChange:(id<ProfileCoordinateObserver>)observer{
    
    [self.coordinateObservers addObject:observer];
}
- (void)dettachObserverForCoordinateChange:(id<ProfileCoordinateObserver>)observer{
    
    if( [self.coordinateObservers containsObject:observer])
        [self.coordinateObservers removeObject:observer];
}
- (void)notifyCoordinateObservers{
    
    for (id<ProfileCoordinateObserver> observer in self.coordinateObservers) {
        [observer updateProfileCoordinate];
    }
}

@end