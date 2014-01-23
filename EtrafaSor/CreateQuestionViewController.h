//
//  CreateQuestionViewController.h
//  EtrafaSor
//
//  Created by Can Firtina on 23/01/14.
//  Copyright (c) 2014 Can Firtina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Profile.h"
#import "EtrafaSorHTTPRequestHandler.h"

@protocol CreateQuestionViewControllerDataSource <NSObject>

@required
@property (nonatomic, strong) Profile *userProfile;
@end

@interface CreateQuestionViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) CreateQuestionViewController *dataSource;
@property (weak, nonatomic) IBOutlet UITextField *questionTopicField;
@property (weak, nonatomic) IBOutlet UITextView *questionDetailed;
@end
