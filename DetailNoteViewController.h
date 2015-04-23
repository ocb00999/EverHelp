//
//  DetailNoteViewController.h
//  EverHelp
//
//  Created by Chubin OU on 3/28/15.
//  Copyright (c) 2015 Chubin OU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import <AVFoundation/AVFoundation.h>

@interface DetailNoteViewController : UIViewController <AVAudioPlayerDelegate>

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *notecontent;
@property (strong, nonatomic) NSNumber *notereward;
@property (strong ,nonatomic) NSString *notetype;
@property (strong, nonatomic) NSDate *notetimelimit;
@property (strong ,nonatomic) AVAudioPlayer *audioPlayer;
@property (strong ,nonatomic) NSData *savedAudioMessage;
@property (strong, nonatomic) NSData *savedImage;
@property (strong, nonatomic) NSString *notestatus;
@property (strong, nonatomic) NSString *notetitle;
@property (strong, nonatomic) PFObject *pfnote;
@property (strong, nonatomic) IBOutlet UILabel *noteTimeLimit;
@property (strong, nonatomic) IBOutlet UILabel *noteTitle;
@property (strong, nonatomic) IBOutlet UILabel *noteContent;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *noteReward;
@property (strong, nonatomic) IBOutlet UIImageView *noteImage;
@property (strong, nonatomic) IBOutlet UIImageView *iconImage;

@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *acceptButton;
@property (strong, nonatomic) IBOutlet UIButton *voiceButton;
@property (strong, nonatomic) NSString *canAcceptTask;

- (IBAction)onVoice:(id)sender;
- (IBAction)onAccept:(id)sender;
- (IBAction)onBack:(id)sender;
- (void)setupViewForNearbyNote:(Note *)note;
- (void)checkCanAcceptTask;


@end
