//
//  Question.h
//  EtrafaSor
//
//  Created by Can Firtina on 22/01/14.
//  Copyright (c) 2014 Can Firtina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Question : NSObject <MKAnnotation>

@property (strong, nonatomic) NSString *topic;
@property (strong, nonatomic) NSArray *messages; //array of messages
@property (nonatomic) BOOL isSolved;

@end
