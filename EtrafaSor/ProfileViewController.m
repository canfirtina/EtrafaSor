//
//  ProfileViewController.m
//  EtrafaSor
//
//  Created by Can Firtina on 22/01/14.
//  Copyright (c) 2014 Can Firtina. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "Profile.h"

@interface ProfileViewController ()
@property (nonatomic, readonly, copy) Profile *userProfile;
@end

@implementation ProfileViewController

@synthesize profileImageView = _profileImageView;
@synthesize answersButton = _answersButton;
@synthesize questionsButton = _questionsButton;
@synthesize userProfile = _userProfile;

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    [self.profileImageView setImageWithURL:self.userProfile.userImageURL placeholderImage:[UIImage imageNamed:@"defaultProfilePicture"]];
    
    self.navigationItem.title = self.userProfile.userName;
}

- (Profile *)userProfile {
    
    return [(AppDelegate *)[[UIApplication sharedApplication] delegate] profile];
}

- (IBAction)logoutPressed:(UIButton *)sender {
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] logout];
}
@end
