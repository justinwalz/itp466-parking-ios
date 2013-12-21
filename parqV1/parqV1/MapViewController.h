//
//  MapViewController.h
//  parq
//
//  Created by Duncan Riefler on 10/28/13.
//  Copyright (c) 2013 Duncan Riefler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>


@interface MapViewController : UIViewController<CLLocationManagerDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate>
{
    CLLocationManager *locationManager;
    // contains a list of pins with info on them
    NSMutableArray * _parkingSpots;
    // used to store the results from the forward geocoding of the given address
    NSArray * _searchPlacemarksCache;
    
    // used to make sure the map doesnt keep zooming in on the users location after finding it
    BOOL atUserLocation;
    
    // used to keep track of which pin is currently selected
    int currentUserUUID;
    
     IBOutlet MKMapView * worldView;
}
@property (nonatomic, retain) IBOutlet MKMapView * worldView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic) NSArray * parkingSpots;
@property (weak, nonatomic) IBOutlet UIButton *userLocationButton;
@property (weak, nonatomic) IBOutlet UIButton *findParkingButton;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *searchBarButton;
- (IBAction)searchBarButtonPressed:(id)sender;

- (IBAction)showUserLocation:(id)sender;

- (IBAction)findParking:(id)sender;
@end
