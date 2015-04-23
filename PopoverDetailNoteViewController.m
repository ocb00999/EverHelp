//
//  PopoverDetailNoteViewController.m
//  EverHelp
//
//  Created by Chubin OU on 3/28/15.
//  Copyright (c) 2015 Chubin OU. All rights reserved.
//

#import "PopoverDetailNoteViewController.h"

@interface PopoverDetailNoteViewController ()

@end

@implementation PopoverDetailNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userName.text = self.username;
    self.userReward.text = [NSString stringWithFormat:@"%@",self.reward];
    self.userContent.text = self.content;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onDetail:(id)sender {
    NSLog(@"didTapOnButton");
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}


- (void)setupViewForNearbyNote:(Note *)note{
    NSLog(@"did");
    self.username = note.username;
    self.reward = note.reward;
    self.content = note.content;
}
@end
