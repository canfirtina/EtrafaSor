//
//  SignUpViewController.h
//  EtrafaSor
//
//  Created by Can Firtina on 25/01/14.
//  Copyright (c) 2014 Can Firtina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@end
