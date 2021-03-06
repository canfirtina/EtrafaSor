//
//  Profile.h
//  EtrafaSor
//
//  Created by Can Firtina on 22/01/14.
//  Copyright (c) 2014 Can Firtina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@protocol ProfileCoordinateObserver <NSObject>

@required
- (void)updateProfileCoordinate;
@end

@interface Profile : NSObject <MKAnnotation>

@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userEMail;
@property (strong, nonatomic) NSURL *userImageURL;
@property (strong, nonatomic) NSArray *questions; //array of questions
@property (strong, nonatomic) NSArray *answers; //array of messages
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

+ (Profile *)profileWithUserId:(NSString *)userId
                         userEmail:(NSString *)userEMail
                         userName:(NSString *)userName
                         imageURL:(NSURL *)imageURL;

//Observer Pattern
- (void)attachObserverForCoordinateChange:(id<ProfileCoordinateObserver>)observer;
- (void)dettachObserverForCoordinateChange:(id<ProfileCoordinateObserver>)observer;
@end