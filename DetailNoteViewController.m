//
//  DetailNoteViewController.m
//  EverHelp
//
//  Created by Chubin OU on 3/28/15.
//  Copyright (c) 2015 Chubin OU. All rights reserved.
//

#import "DetailNoteViewController.h"

@interface DetailNoteViewController ()

@end

@implementation DetailNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.canAcceptTask = @"NO";
    [self checkCanAcceptTask];
    self.userName.text = self.username;
    self.noteContent.text = self.notecontent;
    self.noteReward.text = [NSString stringWithFormat:@"奖赏: $%@",self.notereward];
    self.noteTitle.text = self.notetitle;
    NSDate *timeNow = [NSDate date];
    NSTimeInterval timeLeft = [self.notetimelimit timeIntervalSinceDate:timeNow];
    int hours = timeLeft/3600;
    int minutes = (timeLeft-(hours*3600*24))/60;
    //self.noteTimeLimit.text = [NSString stringWithFormat:@"Time Left: %f",timeLeft];
    if ((hours < 1)&&(minutes <1)) {
        self.noteTimeLimit.text = @"任务已过期";
    } else if (hours >= 1){
        self.noteTimeLimit.text = [NSString stringWithFormat:@"时间剩下: %dH:%dM",hours,minutes];
    } else {
        self.noteTimeLimit.text = [NSString stringWithFormat:@"时间剩下: %dM",minutes];
    }
    UIImage *tmpImage = [UIImage imageWithData:self.savedImage];
    self.noteImage.image = tmpImage;
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
    self.audioPlayer.delegate = self;
    [self.backButton setBackgroundImage:[UIImage imageNamed:@"returnButton.png"] forState:UIControlStateNormal];
    [self.backButton setTitle:nil forState:UIControlStateNormal];
    [self.voiceButton setBackgroundImage:[UIImage imageNamed:@"playButton.png"] forState:UIControlStateNormal];
    [self.voiceButton setTitle:nil forState:UIControlStateNormal];
    [self.acceptButton setBackgroundImage:[UIImage imageNamed:@"acceptButton.png"] forState:UIControlStateNormal];
    [self.acceptButton setTitle:nil forState:UIControlStateNormal];
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:self.username];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error){
            NSLog(@"%lu",(unsigned long)objects.count);
            PFUser *user = [objects firstObject];
            PFFile *tmpFile = user[@"img"];
            NSData *tmpData = [tmpFile getData];
            self.iconImage.image = [UIImage imageWithData:tmpData];
            self.iconImage.layer.cornerRadius = 50;
            self.iconImage.layer.masksToBounds = YES;
            NSLog(@"File size is : %.2f MB",(float)tmpData.length/1024.0f/1024.0f);
        }
    }];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupViewForNearbyNote:(Note *)note{
    self.username = note.username;
    self.notereward = note.reward;
    self.notecontent = note.content;
    self.notetitle = note.title;
    self.notetimelimit = note.timelimit;
    self.savedImage = note.image;
    self.savedAudioMessage = note.voice;
    self.pfnote = note.pfobject;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onVoice:(id)sender {
    if (self.savedAudioMessage == nil) {
        return;
    }
    NSError *err = nil;
    NSLog(@"File size is : %.2f MB",(float)self.savedAudioMessage.length/1024.0f/1024.0f);
    NSLog(@"File size is : %.2f MB",(float)self.savedImage.length/1024.0f/1024.0f);
    self.audioPlayer = [[AVAudioPlayer alloc]initWithData:self.savedAudioMessage error:&err];
    [self.audioPlayer prepareToPlay];
    [self.audioPlayer setVolume:1];
    [self.audioPlayer play];
}

- (IBAction)onAccept:(id)sender {
    if ([self.canAcceptTask isEqualToString:@"YES"]){
        self.pfnote[@"helpername"] = glb_user.username;
        self.pfnote[@"status"] = @"accepted";
        [self.pfnote saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded){
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Your already have an ongoing task！"
                                    message:nil
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil]show];
    }
}

- (void)checkCanAcceptTask{
    PFQuery *query = [PFQuery queryWithClassName:@"Note"];
    [query whereKey:@"status" equalTo:@"accepted"];
    [query whereKey:@"helpername" equalTo:[glb_user getUserName]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error){
            
        } else if (objects.count>0){
            self.canAcceptTask = @"NO";
        } else {
            self.canAcceptTask = @"YES";
        }
    }];
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
