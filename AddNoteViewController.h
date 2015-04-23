//
//  AddNoteViewController.h
//  EverHelp
//
//  Created by Chubin OU on 3/28/15.
//  Copyright (c) 2015 Chubin OU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import <Parse/Parse.h>
#import <CoreLocation/CoreLocation.h>
#import <AVFoundation/AVFoundation.h>

@interface AddNoteViewController : UIViewController <UITextViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVAudioRecorderDelegate, CLLocationManagerDelegate, UITextFieldDelegate>
{
    double userLongitude;
    double userLatitude;
}
- (IBAction)onTypeI:(id)sender;
- (IBAction)onTypeII:(id)sender;
- (IBAction)onTypeIII:(id)sender;
- (IBAction)touchDownVoice:(id)sender;
- (IBAction)touchUpVoice:(id)sender;
- (IBAction)onPickImage:(id)sender;
- (IBAction)onAccept:(id)sender;
- (IBAction)onCancel:(id)sender;
- (void)setTypeButtonColor:(NSInteger)integer;
@property (strong, nonatomic) IBOutlet UIButton *buttonI;
@property (strong, nonatomic) IBOutlet UIButton *buttonII;
@property (strong, nonatomic) IBOutlet UIButton *buttonIII;
@property (strong, nonatomic) IBOutlet UITextField *userTitle;
@property (strong, nonatomic) IBOutlet UITextField *userReward;
@property (strong, nonatomic) NSDate *taskDate;
@property (strong, nonatomic) IBOutlet UIButton *voiceButton;
@property (strong, nonatomic) IBOutlet UIButton *imageButton;
@property (strong, nonatomic) IBOutlet UIButton *acceptButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIImageView *rewardImage;
@property (strong, nonatomic) IBOutlet UIImageView *dateImage;

@property (strong, nonatomic) IBOutlet UITextView *userContent;
@property (strong, nonatomic) IBOutlet UIImageView *userPickImage;

@property (strong ,nonatomic) NSString *noteType;
@property (strong ,nonatomic) AVAudioRecorder *audioRecorder;
@property (strong ,nonatomic) NSData *savedAudioMessage;
@property (strong, nonatomic) NSData *savedImage;
@property (strong, nonatomic) NSString *pathToSave;
@property (strong, nonatomic) CLLocationManager *locationManager;


@property (strong, nonatomic) IBOutlet UISlider *dateSlider;
- (IBAction)dateSliderChanged:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;


@property (strong, nonatomic) IBOutlet UISlider *rewardSlider;
- (IBAction)rewardSliderChanged:(id)sender;


@end
