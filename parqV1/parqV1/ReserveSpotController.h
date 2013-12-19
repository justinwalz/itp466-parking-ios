//
//  ReserveSpotController.h
//  parqV1
//
//  Created by Duncan Riefler on 12/11/13.
//  Copyright (c) 2013 Duncan Riefler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

typedef enum {None,Start,End} DatePickerState;

@interface ReserveSpotController : UIViewController<MKMapViewDelegate>
{
    DatePickerState datePickerState;
}
@property NSDictionary * user;

// Top Part
@property (weak, nonatomic) IBOutlet UIImageView *ProfPic;
@property (weak, nonatomic) IBOutlet UIImageView *parkingSpotView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *numPrevParkers;

// Middle Part
@property (weak, nonatomic) IBOutlet UILabel *numHours;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet MKMapView *parkingMapView;


// Bottom Part
@property (weak, nonatomic) IBOutlet UILabel *totalWantedHours;
@property (weak, nonatomic) IBOutlet UILabel *totalAmount;
@property (weak, nonatomic) IBOutlet UIButton *startTime;
@property (weak, nonatomic) IBOutlet UIButton *endTime;
@property (weak, nonatomic) IBOutlet UIButton *reserveButton;

- (id) initWithMapView: (MKMapView *) currentMapView andUser: (NSDictionary *) usr;
- (IBAction)reserveButtonPressed:(id)sender;

// ------ TOP SECTION ------//
// User Name
- (NSString *) getUserName ;
- (void) setUserName:(NSString *) name;

// Rating
- (int) getRating ;
- (void) setRating:(int) rating;

// Number of parkers
- (int) getNumParkers ;
- (void) setNumParkers:(int) numParkers ;

// Profile picture
- (NSString *) getProfPic ;
- (void) setProfilePic:(NSString *)profPic ;

// Driveway picture
- (NSString *) getDrivewayPic ;
- (void) setDrivewayPic:(NSString *)parkingView;

// ------ MIDDLE SECTION ------//

// Hours Available
- (NSString *) getHoursAvailable ;
- (void) setHoursAvailable:(NSString *) hours;
// Hourly Rate
- (double) getHourlyRate;
- (void) setHourlyRate:(double) rate ;
// Address
- (NSString *) getAddress;
- (void) setTheAddress:(NSString *) addr;

// ------ BOTTOM SECTION ------//

// Wanted Hours
- (float) getNumWantedHours;
- (void) setNumWantedHours:(float) wntd;

// Price
- (double) getTotalPrice ;
- (void) setTotalPrice:(double) pr;

// Start Time
- (NSDate *) getStartTime ;
- (void) setTheStartTime:(NSDate *) date ;

// End Time
- (NSDate *) getEndTime ;
- (void) setTheEndTime:(NSDate *) date;


@end
