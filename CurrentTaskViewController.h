//
//  CurrentTaskViewController.h
//  EverHelp
//
//  Created by Chubin OU on 3/28/15.
//  Copyright (c) 2015 Chubin OU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"
#import "Common.h"


@interface CurrentTaskViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
- (IBAction)onBack:(id)sender;
- (IBAction)onSent:(id)sender;
- (IBAction)onComplete:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *inputText;
@property (strong, nonatomic) IBOutlet UITableView *chatTable;
@property (strong, nonatomic) IBOutlet UILabel *chatTitle;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *theotherusername;
@property (strong, nonatomic) NSMutableArray *chatHistory;
@property (strong, nonatomic) NSString *role;
@property (strong, nonatomic) PFObject *currentTask;
@property (strong, nonatomic) IBOutlet UIButton *completeButton;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UILabel *taskTitle;
@property (strong, nonatomic) IBOutlet UILabel *timeLeft;


- (void)fetchChat;
- (void) setupButtonForRole:(NSString *)role;

@end
