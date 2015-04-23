//
//  MapViewController.m
//  EverHelp
//
//  Created by Chubin OU on 3/28/15.
//  Copyright (c) 2015 Chubin OU. All rights reserved.
//

#import "MapViewController.h"





@interface MapViewController ()

@end

@implementation MapViewController{
    dispatch_source_t _timer;
    BOOL canUpdateNearbyNote;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    canUpdateNearbyNote = YES;
    [self hideBottomMenu];
    self.mapView.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self setupButton];
    
    // Do any additional setup after loading the view.
}

- (void)setupButton{
    [self.locationManager requestAlwaysAuthorization];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [self.addButton setBackgroundImage:[UIImage imageNamed:@"plusButton.png"] forState:UIControlStateNormal];
    [self.addButton setBackgroundImage:[UIImage imageNamed:@"plusButtonPressed.png"] forState:UIControlStateSelected];
    [self.addButton setTitle:nil forState:UIControlStateNormal];
    
    [self.profileButton setBackgroundImage:glb_user.img forState:UIControlStateNormal];
    [self.profileButton setTitle:nil forState:UIControlStateNormal];
    self.profileButton.layer.cornerRadius = 19.5;
    self.profileButton.layer.masksToBounds = YES;
    
    [self.detailButton setBackgroundImage:[UIImage imageNamed:@"detailButton.png"] forState:UIControlStateNormal];
    [self.detailButton setTitle:nil forState:UIControlStateNormal];
    
    
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

- (void)hideBottomMenu{
    [self.bottomBar setHidden:YES];
    [self.detailButton setHidden:YES];
    [self.noteTitle setHidden:YES];
    [self.noteReward setHidden:YES];
    [self.annotationIcon setHidden:YES];
    [self.noteUserName setHidden:YES];
}

- (void)showBottomMenu{
    [self.bottomBar setHidden:NO];
    [self.detailButton setHidden:NO];
    [self.noteTitle setHidden:NO];
    [self.noteReward setHidden:NO];
    [self.annotationIcon setHidden:NO];
    [self.noteUserName setHidden:NO];
}
- (IBAction)onAdd:(id)sender {
    [self performSegueWithIdentifier:@"toAddNoteView" sender:self];
}

- (IBAction)onProfile:(id)sender {
    [self performSegueWithIdentifier:@"toProfileView" sender:self];
}

- (IBAction)onDetail:(id)sender {
    [self performSegueWithIdentifier:@"toDetailNoteView" sender:self];
}



- (void)updateNearbyNote{
    if (canUpdateNearbyNote){
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (!error){
            PFQuery *query = [PFQuery queryWithClassName:@"Note"];
            [query whereKey:@"location" nearGeoPoint:geoPoint withinKilometers:10.0f];
            [query whereKey:@"username" notEqualTo:[glb_user getUserName]];
            [query whereKey:@"status" equalTo:@"sent"];
            query.limit = 10;
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error){
                    [self.mapView removeAnnotations:self.mapView.annotations];
                    
                    [glb_user.nearbyNoteList removeAllObjects];
                    for (PFObject *ob in objects){
                        [glb_user addNearByNote:ob];
                        MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
                        PFGeoPoint *annotationLocation = ob[@"location"];
                        CLLocationCoordinate2D mapcoord = CLLocationCoordinate2DMake(annotationLocation.latitude, annotationLocation.longitude);
                        [annotation setCoordinate:mapcoord];
                        [annotation setTitle:ob[@"title"]];
                        [self.mapView addAnnotation:annotation];
                    
                    }
                    //NSLog(@"%lu",(unsigned long)self.mapView.annotations.count);
                }
            }];
            
        }
    }];
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    canUpdateNearbyNote = NO;
    MKPointAnnotation *selected = [self.mapView.selectedAnnotations firstObject];
    NSString *noteTitle = selected.title;
    /*NSUInteger index = [self.mapView.annotations indexOfObject:view.annotation];
    Note *tmpNote = [glb_user.nearbyNoteList objectAtIndex:index];
    NSLog(@"%@",tmpNote.username);*/
    Note *tmpNote;
    for (Note *ob in glb_user.nearbyNoteList){
        if ([ob.title isEqualToString:noteTitle]) {
            tmpNote = ob;
        }
    }
    self.noteTitle.text = tmpNote.title;
    self.noteUserName.text = tmpNote.username;
    self.noteReward.text = [NSString stringWithFormat:@"$%@",tmpNote.reward];
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:tmpNote.username];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error){
            NSLog(@"%lu",(unsigned long)objects.count);
            PFUser *user = [objects firstObject];
            PFFile *tmpFile = user[@"img"];
            NSData *tmpData = [tmpFile getData];
            self.annotationIcon.image = [UIImage imageWithData:tmpData];
            NSLog(@"File size is : %.2f MB",(float)tmpData.length/1024.0f/1024.0f);

        }
    }];
    self.annotationIcon.layer.cornerRadius = 40;
    self.annotationIcon.layer.masksToBounds = YES;
    //selectedAnnotationIndex = index;
    [self showBottomMenu];
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    canUpdateNearbyNote = YES;
    [self hideBottomMenu];
}

#pragma CLLocation Update
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
        CLLocationCoordinate2D mapcoord = currentLocation.coordinate;
        mapcoord = currentLocation.coordinate;
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(mapcoord, 1000, 1000);
        [self.mapView setRegion:region animated:YES];
        PFGeoPoint *updatedUserLocation = [PFGeoPoint geoPointWithLatitude:mapcoord.latitude longitude:mapcoord.longitude];
        PFUser *user = [glb_user getPFUser];
        user[@"location"]=updatedUserLocation;
        [user saveInBackground];
    }
}

#pragma Periodically Fetch From Parse
dispatch_source_t CreateDispatchTimer(double interval, dispatch_queue_t queue, dispatch_block_t block)
{
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    if (timer)
    {
        dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, interval * NSEC_PER_SEC), interval * NSEC_PER_SEC, (1ull * NSEC_PER_SEC) / 10);
        dispatch_source_set_event_handler(timer, block);
        dispatch_resume(timer);
    }
    return timer;
}
- (void)startTimer
{
    //dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    double secondsToFire = 10.0f;
    
    _timer = CreateDispatchTimer(secondsToFire, dispatch_get_main_queue(), ^{
        // Do something
        [self updateNearbyNote];
    });
}

- (void)cancelTimer
{
    if (_timer) {
        dispatch_source_cancel(_timer);
        // Remove this if you are on a Deployment Target of iOS6 or OSX 10.8 and above
        _timer = nil;
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [self.locationManager startUpdatingLocation];
    canUpdateNearbyNote = YES;
    [self.profileButton setBackgroundImage:glb_user.img forState:UIControlStateNormal];
    [self.profileButton setTitle:nil forState:UIControlStateNormal];
    [self updateNearbyNote];
    [self startTimer];
}

- (void)viewDidDisappear:(BOOL)animated{
    [self.locationManager stopUpdatingLocation];
    [self cancelTimer];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"toDetailNoteView"])
    {
        // Get reference to the destination view controller
        if (self.selectedNote != 1000) {
            DetailNoteViewController *transferView = [segue destinationViewController];
            [transferView setupViewForNearbyNote:[glb_user.nearbyNoteList objectAtIndex:self.selectedNote]];
        }
    }
}

- (NSUInteger)selectedNote{
    MKPointAnnotation *tmpAnnotation = [self.mapView.selectedAnnotations firstObject];
    NSString *noteTitle = tmpAnnotation.title;
    for (Note *ob in glb_user.nearbyNoteList){
        if ([ob.title isEqualToString:noteTitle]) {
            return [glb_user.nearbyNoteList indexOfObject:ob];
        }
    }
    return 1000;
}

- (void)presentCongratViewWithContent:(NSString *)content{
    [self performSegueWithIdentifier:@"toCongratView" sender:self];
}

- (void)presentProfileView{
    [self performSegueWithIdentifier:@"toProfileView" sender:self];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Button 1"])
    {
        NSLog(@"Button 1 was selected.");
    }
    else if([title isEqualToString:@"Button 2"])
    {
        NSLog(@"Button 2 was selected.");
    }
    else if([title isEqualToString:@"Button 3"])
    {
        NSLog(@"Button 3 was selected.");
    }
}



@end
