//
//  LoginViewController.h
//  EtrafaSor
//
//  Created by Can Firtina on 21/01/14.
//  Copyright (c) 2014 Can Firtina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userEmailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

- (IBAction)dismissByCancelToLoginViewController:(UIStoryboardSegue *)segue;
@end
