//
//  AddNoteViewController.m
//  EverHelp
//
//  Created by Chubin OU on 3/28/15.
//  Copyright (c) 2015 Chubin OU. All rights reserved.
//

#import "AddNoteViewController.h"
#import "SVProgressHUD.h"



@interface AddNoteViewController ()

@end

@implementation AddNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userContent.delegate = self;
    self.userTitle.delegate = self;
    self.userTitle.placeholder = @"求助标题";
    self.userContent.text = @"求助内容";
    self.userContent.textColor = [UIColor lightGrayColor];
    self.userReward.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [self setTypeButtonColor:1];
    self.noteType = @"Type I";
    userLatitude = 0.0; userLongitude = 0.0;
    self.rewardImage.image = [UIImage imageNamed:@"rewardIcon.png"];
    self.dateImage.image = [UIImage imageNamed:@"stopwatch.png"];
    
    self.rewardSlider.maximumValue = 3.0;
    self.rewardSlider.minimumValue = 0.0;
    self.dateSlider.maximumValue = 180;
    self.dateSlider.minimumValue = 0.0;
    
    self.taskDate = [NSDate date];
    
    [self.voiceButton setBackgroundImage:[UIImage imageNamed:@"voiceButton.png"] forState:UIControlStateNormal];
    [self.voiceButton setTitle:nil forState:UIControlStateNormal];
    [self.imageButton setBackgroundImage:[UIImage imageNamed:@"cameraButton.png"] forState:UIControlStateNormal];
    [self.imageButton setTitle:nil forState:UIControlStateNormal];
    [self.acceptButton setBackgroundImage:[UIImage imageNamed:@"postButton.png"] forState:UIControlStateNormal];
    [self.acceptButton setTitle:nil forState:UIControlStateNormal];
    [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"returnButton.png"] forState:UIControlStateNormal];
    [self.cancelButton setTitle:nil forState:UIControlStateNormal];
    [self.buttonI setBackgroundImage:[UIImage imageNamed:@"labourButton"] forState:UIControlStateNormal];
    [self.buttonI setTitle:nil forState:UIControlStateNormal];
    
    [self.buttonII setBackgroundImage:[UIImage imageNamed:@"knowButton"] forState:UIControlStateNormal];
    [self.buttonII setTitle:nil forState:UIControlStateNormal];
    
    [self.buttonIII setBackgroundImage:[UIImage imageNamed:@"lendButton"] forState:UIControlStateNormal];
    [self.buttonIII setTitle:nil forState:UIControlStateNormal];
    
    if([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)])
    {
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            NSLog(@"Obtained Record Permission");
        }];
    }
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
    self.audioRecorder.delegate = self;
    NSDictionary *recordSettings = [NSDictionary
                                    dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:AVAudioQualityMin],
                                    AVEncoderAudioQualityKey,
                                    [NSNumber numberWithInt:16],
                                    AVEncoderBitRateKey,
                                    [NSNumber numberWithInt: 2],
                                    AVNumberOfChannelsKey,
                                    [NSNumber numberWithFloat:44100.0],
                                    AVSampleRateKey,
                                    nil];
    NSArray *searchPaths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath_ = [searchPaths objectAtIndex: 0];
    self.pathToSave = [documentPath_ stringByAppendingPathComponent:@"tempVoiceMessage.caf"];
    NSURL *url = [NSURL fileURLWithPath:self.pathToSave];
    NSError *err = nil;
    self.audioRecorder = [[AVAudioRecorder alloc]initWithURL:url settings:recordSettings error:&err];
    
    UIImage *defaultTaskImage = [UIImage imageNamed:@"defaultTask.png"];
    NSData *tmpImageData = UIImageJPEGRepresentation(defaultTaskImage, 0.1);
    self.savedImage = tmpImageData;
    
    

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

- (IBAction)onTypeI:(id)sender {
    self.noteType = @"Type I";
    [self setTypeButtonColor:1];
}

- (IBAction)onTypeII:(id)sender {
    self.noteType = @"Type II";
    [self setTypeButtonColor:2];
}

- (IBAction)onTypeIII:(id)sender {
    self.noteType = @"Type III";
    [self setTypeButtonColor:3];
}

- (void)setTypeButtonColor:(NSInteger)integer {
    //[self.buttonI setBackgroundColor:[UIColor clearColor]];
    [self.buttonI setBackgroundImage:[UIImage imageNamed:@"labourButton.png"] forState:UIControlStateNormal];
    //[self.buttonII setBackgroundColor:[UIColor clearColor]];
    [self.buttonII setBackgroundImage:[UIImage imageNamed:@"knowButton.png"] forState:UIControlStateNormal];
    //[self.buttonIII setBackgroundColor:[UIColor clearColor]];
    [self.buttonIII setBackgroundImage:[UIImage imageNamed:@"lendButton.png"] forState:UIControlStateNormal];
    if (integer == 1){
       
        [self.buttonI setBackgroundImage:[UIImage imageNamed:@"labourButtonPressed.png"] forState:UIControlStateNormal];
    } else if (integer ==2){
        [self.buttonII setBackgroundImage:[UIImage imageNamed:@"knowButtonPressed.png"] forState:UIControlStateNormal];
    } else if (integer ==3){
        [self.buttonIII setBackgroundImage:[UIImage imageNamed:@"lendButtonPressed"] forState:UIControlStateNormal];
    }
}

- (IBAction)touchDownVoice:(id)sender {
    NSLog(@"Recording...");
    [self.audioRecorder prepareToRecord];
    [self.audioRecorder record];
}

- (IBAction)touchUpVoice:(id)sender {
    NSLog(@"Recording ended");
    [self.audioRecorder stop];
    NSData *data = [[NSData alloc] initWithContentsOfFile:self.pathToSave];
    self.savedAudioMessage = data;
    NSLog(@"File size is : %.2f MB",(float)data.length/1024.0f/1024.0f);
}

- (IBAction)onPickImage:(id)sender {
    UIActionSheet *actions = [[UIActionSheet alloc] initWithTitle:@"Adding Note Image"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Take Photo",@"Choose Existing", nil];
    actions.delegate = self;
    [actions showInView:self.view.window];
}

- (IBAction)onAccept:(id)sender {
    PFObject *newnote = [PFObject objectWithClassName:@"Note"];
    newnote[@"username"] = [glb_user getUserName];
    newnote[@"content"] = self.userContent.text;
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *rewardNumber = [f numberFromString:self.userReward.text];
    newnote[@"reward"] = rewardNumber;
    newnote[@"helpername"] = @"None";
    PFGeoPoint *notelocation = [PFGeoPoint geoPointWithLatitude:userLatitude
                                                      longitude:userLongitude];
    newnote[@"title"] = self.userTitle.text;
    newnote[@"location"] = notelocation;
    newnote[@"status"] = @"sent";
    if (self.savedAudioMessage){
        PFFile *audioFile = [PFFile fileWithData:self.savedAudioMessage];
        newnote[@"voice"] = audioFile;
    }
    PFFile *imageFile = [PFFile fileWithData:self.savedImage];
    newnote[@"image"] = imageFile;
    newnote[@"timelimit"] = self.taskDate;
    
    [glb_user addNote:newnote];
    [SVProgressHUD showWithStatus:@"Saving..."];
    [newnote saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded){
            [SVProgressHUD dismiss];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (IBAction)onCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//TextView
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    textView.textColor = [UIColor blackColor];
    return YES;
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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

//ImagePicker
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *resizedImage = squareCropImageToSideLength(image, 90);

    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSData *tmpimageData = UIImageJPEGRepresentation(resizedImage, 0.1f);
    
    self.savedImage = tmpimageData;
    
    self.userPickImage.image = [UIImage imageWithData:self.savedImage];
}

//ImagePicker
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


//CLLocation
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        userLongitude = currentLocation.coordinate.longitude;
        userLatitude = currentLocation.coordinate.latitude;
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [self.locationManager startUpdatingLocation];
}

- (void)viewDidDisappear:(BOOL)animated{
    [self.locationManager stopUpdatingLocation];
}


- (IBAction)dateSliderChanged:(id)sender {
    int hours = floor(self.dateSlider.value/60);
    int minutes = self.dateSlider.value - 60*hours;
    self.taskDate = [[NSDate date]dateByAddingTimeInterval:60*60*hours+60*minutes];
    if (hours != 0){
        self.dateLabel.text = [NSString stringWithFormat:@"%dH:%dM",hours,minutes];
    } else {
        self.dateLabel.text = [NSString stringWithFormat:@"%dM",minutes];
    }
}
- (IBAction)rewardSliderChanged:(id)sender {
    float roundedValue = round(powf(10,self.rewardSlider.value));
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:0];
    [formatter setRoundingMode: NSNumberFormatterRoundDown];
    NSString *numberString = [formatter stringFromNumber:[NSNumber numberWithFloat:roundedValue]];
    self.userReward.text = [NSString stringWithFormat:@"%@",numberString];
}

UIImage *squareCropImageToSideLength(UIImage *sourceImage,
                                     CGFloat sideLength)
{
    // input size comes from image
    CGSize inputSize = sourceImage.size;
    
    // round up side length to avoid fractional output size
    sideLength = ceilf(sideLength);
    
    // output size has sideLength for both dimensions
    CGSize outputSize = CGSizeMake(sideLength, sideLength);
    
    // calculate scale so that smaller dimension fits sideLength
    CGFloat scale = MAX(sideLength / inputSize.width,
                        sideLength / inputSize.height);
    
    // scaling the image with this scale results in this output size
    CGSize scaledInputSize = CGSizeMake(inputSize.width * scale,
                                        inputSize.height * scale);
    
    // determine point in center of "canvas"
    CGPoint center = CGPointMake(outputSize.width/2.0,
                                 outputSize.height/2.0);
    
    // calculate drawing rect relative to output Size
    CGRect outputRect = CGRectMake(center.x - scaledInputSize.width/2.0,
                                   center.y - scaledInputSize.height/2.0,
                                   scaledInputSize.width,
                                   scaledInputSize.height);
    
    // begin a new bitmap context, scale 0 takes display scale
    UIGraphicsBeginImageContextWithOptions(outputSize, YES, 0);
    
    // optional: set the interpolation quality.
    // For this you need to grab the underlying CGContext
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(ctx, kCGInterpolationHigh);
    
    // draw the source image into the calculated rect
    [sourceImage drawInRect:outputRect];
    
    // create new image from bitmap context
    UIImage *outImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // clean up
    UIGraphicsEndImageContext();
    
    // pass back new image
    return outImage;
}
@end
