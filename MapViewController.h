//
//  MapViewController.h
//  EverHelp
//
//  Created by Chubin OU on 3/28/15.
//  Copyright (c) 2015 Chubin OU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import "Common.h"
#import <CoreLocation/CoreLocation.h>
#import "PopoverDetailNoteViewController.h"
#import "DetailNoteViewController.h"

@interface MapViewController : UIViewController <MKMapViewDelegate, MKAnnotation, CLLocationManagerDelegate, UIAlertViewDelegate>
- (IBAction)onAdd:(id)sender;
- (IBAction)onProfile:(id)sender;
- (IBAction)onDetail:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *bottomBar;
@property (strong, nonatomic) IBOutlet UILabel *noteTitle;
@property (strong, nonatomic) IBOutlet UILabel *noteReward;
@property (strong, nonatomic) IBOutlet UIButton *addButton;
@property (strong, nonatomic) IBOutlet UIButton *detailButton;
@property (strong, nonatomic) IBOutlet UIImageView *annotationIcon;
@property (strong, nonatomic) IBOutlet UILabel *noteUserName;

@property (strong, nonatomic) IBOutlet UIButton *profileButton;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;

- (void)presentCongratViewWithContent:(NSString *)content;
- (void)presentProfileView;

- (void)updateNearbyNote;
- (NSUInteger)selectedNote;
@end
