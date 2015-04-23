//
//  ProfileViewController.h
//  EverHelp
//
//  Created by Chubin OU on 3/28/15.
//  Copyright (c) 2015 Chubin OU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Common.h"
#import "SVProgressHUD.h"

@interface ProfileViewController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *userIcon;

@property (strong, nonatomic) IBOutlet UILabel *userCash;
- (IBAction)onCurrentTask:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *userDonation;
@property (strong, nonatomic) IBOutlet UILabel *userReward;
@property (strong, nonatomic) IBOutlet UILabel *userRanking;
@property (strong, nonatomic) IBOutlet UILabel *taskCompleted;

@property (strong, nonatomic) IBOutlet UIButton *backButton;

- (IBAction)onBack:(id)sender;

- (void)changeIcon;

@end
