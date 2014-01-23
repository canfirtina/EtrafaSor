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
- (void)updateProfileCoordinate;
@end

@interface Profile : NSObject <MKAnnotation>

@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userEMail;
@property (strong, nonatomic) NSURL *userImageURL;
@property (strong, nonatomic) NSArray *questions; //array of questions
@property (strong, nonatomic) NSArray *answers; //array of messages
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

+ (Profile *)profileWithUserEMail:(NSString *)userEMail
                         userName:(NSString *)userName;

- (void)attachObserverForCoordinateChange:(id<ProfileCoordinateObserver>)observer;

@end
