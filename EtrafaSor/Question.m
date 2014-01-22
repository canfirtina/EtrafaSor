//
//  Question.m
//  EtrafaSor
//
//  Created by Can Firtina on 22/01/14.
//  Copyright (c) 2014 Can Firtina. All rights reserved.
//

#import "Question.h"

@implementation Question

@synthesize coordinate = _coordinate;
@synthesize title = _title;
@synthesize subtitle = _subtitle;
@synthesize messages = _messages;
@synthesize topic = _topic;
@synthesize isSolved = _isSolved;

#pragma mark - Setters & Getters

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate { _coordinate = newCoordinate; }

- (NSString *)title { return self.topic; }

- (NSString *)subtitle { return [self.messages objectAtIndex:0]; }

- (NSArray *)messages {
    
    if( !_messages){
        _messages = [NSArray array];
    }
    
    return _messages;
}
@end
