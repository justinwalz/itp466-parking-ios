//
//  MapViewController.h
//  parq
//
//  Created by Duncan Riefler on 10/28/13.
//  Copyright (c) 2013 Duncan Riefler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController<CLLocationManagerDelegate, MKMapViewDelegate>
{
    CLLocationManager *locationManager;
    // contains a list of pins with info on them
    NSMutableArray * _parkingSpots;
    // used to store the results from the forward geocoding of the given address
    NSArray * _searchPlacemarksCache;
    
     IBOutlet MKMapView * worldView;
}
@property (nonatomic, retain) IBOutlet MKMapView * worldView;
@property (nonatomic) NSArray * parkingSpots;

- (IBAction)findParking:(id)sender;
@end
