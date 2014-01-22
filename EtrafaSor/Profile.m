//
//  Profile.m
//  EtrafaSor
//
//  Created by Can Firtina on 22/01/14.
//  Copyright (c) 2014 Can Firtina. All rights reserved.
//

#import "Profile.h"

@implementation Profile

@synthesize coordinate = _coordinate;
@synthesize title = _title;
//@synthesize subtitle = _subtitle;
@synthesize userName = _userName;
@synthesize userEMail = _userEMail;
@synthesize userImageURL = _userImageURL;
@synthesize questions = _questions;
@synthesize answers = _answers;


#pragma mark - Setters & Getters

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate { _coordinate = newCoordinate; }

- (NSString *)title { return self.userName; }

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

@end
