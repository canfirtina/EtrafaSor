//
//  Profile.h
//  EtrafaSor
//
//  Created by Can Firtina on 22/01/14.
//  Copyright (c) 2014 Can Firtina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Profile : NSObject <MKAnnotation>

@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userEMail;
@property (strong, nonatomic) NSURL *userImageURL;
@property (strong, nonatomic) NSArray *questions;
@property (strong, nonatomic) NSArray *answers;
@end
