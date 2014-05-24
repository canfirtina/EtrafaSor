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

@protocol CreateQuestionDelegate <NSObject>

- (void)questionPostedSuccessfully;

@end
@interface CreateQuestionViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *questionTopicField;
@property (weak, nonatomic) IBOutlet UITextView *questionDetailed;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sendMessageButton;
@property (nonatomic) id<CreateQuestionDelegate> delegate;

- (IBAction)sendMessagePressed:(UIBarButtonItem *)sender;
@end
