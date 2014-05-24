//
//  LoginViewController.h
//  EtrafaSor
//
//  Created by Can Firtina on 21/01/14.
//  Copyright (c) 2014 Can Firtina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EtrafaSorHTTPRequestHandler.h"

@protocol LoginResultResponser <NSObject>

@required

- (void)loginSucceededWithUserProfile:(Profile *)userProfile
                         forUserEMail:(NSString *)userEMail
                             password:(NSString *)password
                            sessionId:(NSString *)sessionId;

@end

@interface LoginViewController : UIViewController <UITextFieldDelegate, EtrafaSorHTTPRequestHandlerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userEmailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (nonatomic) id<LoginResultResponser> loginResponseDelegate;

- (IBAction)dismissByCancelToLoginViewController:(UIStoryboardSegue *)segue;
@end
