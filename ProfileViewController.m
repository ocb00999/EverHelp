//
//  ProfileViewController.m
//  EverHelp
//
//  Created by Chubin OU on 3/28/15.
//  Copyright (c) 2015 Chubin OU. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController{
    BOOL canEnterTaskView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    canEnterTaskView = NO;
    if (glb_user.img == nil){
        self.userIcon.image = [UIImage imageNamed:@"defaultUserIcon.jpg"];
    } else {
        self.userIcon.image = glb_user.img;
    }
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self action:@selector(changeIcon) forControlEvents:UIControlEventAllEvents];
    
    self.userIcon.layer.cornerRadius = 80;
    self.userIcon.layer.masksToBounds = YES;
    button.frame = CGRectMake(0.0, 0.0, 160, 160);
    [self.userIcon addSubview:button];
    
    self.userCash.text = [NSString stringWithFormat:@"$: %@",glb_user.cash];
    self.userRanking.text = [NSString stringWithFormat:@"Rank: %@",glb_user.rank];
    self.userDonation.text = [NSString stringWithFormat:@"%@",glb_user.donation];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setPositiveFormat:@"0.00%;0.00%;-0.00%"];
    self.userReward.text = [NSString stringWithFormat:@"%@",[formatter stringFromNumber:glb_user.reward]];
    self.taskCompleted.text = [NSString stringWithFormat:@"%@",glb_user.taskCompleted];
    [self.backButton setBackgroundImage:[UIImage imageNamed:@"returnButton.png"] forState:UIControlStateNormal];
    [self.backButton setTitle:nil forState:UIControlStateNormal];
    /*PFQuery *query1 = [PFQuery queryWithClassName:@"Note"];
    [query1 whereKey:@"status" equalTo:@"completed"];
    [query1 whereKey:@"helpername" equalTo:glb_user.username];
    [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error){
            self.taskCompleted.text = [NSString stringWithFormat:@"%lu Completed Tasks",(unsigned long)objects.count];
        }
    }];*/
    PFQuery *query2 = [PFQuery queryWithClassName:@"Note"];
    [query2 whereKey:@"status" equalTo:@"accepted"];
    [query2 whereKey:@"helpername" equalTo:glb_user.username];
    [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error){
            if (objects.count !=0){
                canEnterTaskView = YES;
            }
            PFQuery *query3 = [PFQuery queryWithClassName:@"Note"];
            [query3 whereKey:@"status" equalTo:@"accepted"];
            [query3 whereKey:@"username" equalTo:glb_user.username];
            [query3 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error){
                    if (objects.count !=0){
                        canEnterTaskView = YES;
                    }
                }
            }];
        }
    }];
    
    // Do any additional setup after loading the view.
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

- (IBAction)onCurrentTask:(id)sender {
    if (canEnterTaskView){
        [self performSegueWithIdentifier:@"toCurrentTask" sender:self];
    }
}



- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)changeIcon{
    NSLog(@"change icon");
    UIActionSheet *actions = [[UIActionSheet alloc] initWithTitle:@"Adding Note Image"
                                                         delegate:self
                                                cancelButtonTitle:@"Cancel"
                                           destructiveButtonTitle:nil
                                                otherButtonTitles:@"Take Photo",@"Choose Existing", nil];
    actions.delegate = self;
    [actions showInView:self.view.window];
}

//ImagePicker
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    UIImage *resizedImage = image;
    CGFloat width = 300;
    CGFloat height = image.size.height / image.size.width * width;
    
    if (image.size.width > width) {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, [UIScreen mainScreen].scale);
        [image drawInRect:CGRectMake(0, 0, width, height)];
        resizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSData *tmpimageData = UIImageJPEGRepresentation(resizedImage, 0.1f);
    PFFile *tmpPFFile = [PFFile fileWithData:tmpimageData];
    PFUser *user = [PFUser currentUser];
    user[@"img"] = tmpPFFile;
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded){
            
        }
    }];
    glb_user.img = [UIImage imageWithData:tmpimageData];
    self.userIcon.image = [UIImage imageWithData:tmpimageData];
}

//ImagePicker
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//ActionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        if (buttonIndex == 0) {
            if (![UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
                [[[UIAlertView alloc] initWithTitle:@"Your device does not support photos！"
                                            message:nil
                                           delegate:nil
                                  cancelButtonTitle:@"Cancel"
                                  otherButtonTitles:nil]show];
                return;
            }
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.delegate = self;
            picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            [picker setShowsCameraControls:YES];
            picker.allowsEditing = YES;
            picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            picker.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
            [self presentViewController:picker animated:YES completion:nil];
        }
        else {
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                [[[UIAlertView alloc] initWithTitle:@"Your device does not support！"
                                            message:nil
                                           delegate:nil
                                  cancelButtonTitle:@"Cancel"
                                  otherButtonTitles:nil] show];
                return;
            }
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:nil];
        }
    }
}


@end
