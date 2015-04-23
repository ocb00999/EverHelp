//
//  LoginViewController.h
//  EverHelp
//
//  Created by Chubin OU on 3/28/15.
//  Copyright (c) 2015 Chubin OU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate>;

@property (strong, nonatomic) IBOutlet UITextField *userName;
@property (strong, nonatomic) IBOutlet UITextField *userPassword;
- (IBAction)onSignIn:(id)sender;
- (IBAction)onSignUp:(id)sender;
@end
