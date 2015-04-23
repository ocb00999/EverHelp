//
//  PopoverDetailNoteViewController.h
//  EverHelp
//
//  Created by Chubin OU on 3/28/15.
//  Copyright (c) 2015 Chubin OU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"

@interface PopoverDetailNoteViewController : UIViewController
- (IBAction)onDetail:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *userReward;
@property (strong, nonatomic) IBOutlet UILabel *userContent;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSNumber *reward;
- (void)setupViewForNearbyNote:(Note *)note;


@end
