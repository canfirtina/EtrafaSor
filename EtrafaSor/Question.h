//
//  Question.h
//  EtrafaSor
//
//  Created by Can Firtina on 22/01/14.
//  Copyright (c) 2014 Can Firtina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Profile.h"

@interface Question : NSObject <MKAnnotation>

@property (strong, nonatomic) NSString *topic;
@property (strong, nonatomic, readonly) NSArray *messages; //array of messages
@property (nonatomic) BOOL isSolved;

typedef void (^postCompletionBlock)(BOOL succeeded);

+ (Question *)questionWithTopic:(NSString *)topic questionMessage:(NSString *)question owner:(Profile *)owner;

- (void)postMessage:(NSString *)text forUser:(Profile *)user usingBlock:(postCompletionBlock)completionBlock;
@end
