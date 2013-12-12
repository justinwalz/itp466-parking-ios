//
//  MapViewController.m
//  parq
//
//  Created by Duncan Riefler on 10/28/13.
//  Copyright (c) 2013 Duncan Riefler. All rights reserved.
//

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1
#define kLatestParkingSpotsURL [NSURL URLWithString:@"http://54.200.32.8:3000/sample.json"] //2


#import "MapViewController.h"
#import "MapPin.h"
#import "AddParkingSpotController.h"

@implementation MapViewController
@synthesize parkingSpots, worldView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Create location manager object
        locationManager = [[CLLocationManager alloc] init];
        [locationManager setDelegate:self];
        
        // And we want it to be as accurate as possible regardless of how much time/power it takes
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        
        [self setUpNavBar];
//        // Create a pin on the map from an address
//        CLGeocoder * geocoder = [[CLGeocoder alloc] init];
//        [geocoder geocodeAddressString:@"707 West 28th Street, Los Angeles, CA, 90007, USA"
//                     completionHandler:^(NSArray* placemarks, NSError* error){
//                         _searchPlacemarksCache = [[NSArray alloc]initWithArray:placemarks];
//                     }];
//        MapPin * pin1 = [[MapPin alloc] initWithLocation:[_searchPlacemarksCache objectAtIndex:0] andRating:4 andRate:4.25 andStartTime:2 andEndTime:8];
//        _parkingSpots = [[NSMutableArray alloc] initWithObjects:pin1, nil];
    }
    return self;
}

- (void)setUpNavBar
{

}

- (void)loadAddParkingSpotView
{
    AddParkingSpotController *apsc = [[AddParkingSpotController alloc] initWithNibName:@"AddParkingSpotController" bundle:nil];
    [[self navigationController] pushViewController:apsc animated:YES];
}

- (IBAction)findParking:(id)sender
{
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Map Stuff
    [self.worldView setDelegate:self];
    [self.worldView setShowsUserLocation:YES];
    [self.worldView setMapType:MKMapTypeStandard];
    
    // NavBar stuff
    [self setTitle:@"parq"];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                  target:self
                                  action:@selector(loadAddParkingSpotView)];
    [[self navigationItem] setRightBarButtonItem:barButton];
    
    // Request parking spot data
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        kLatestParkingSpotsURL];
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:data waitUntilDone:YES];
    });
}

- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          
                          options:kNilOptions
                          error:&error];
    
    parkingSpots = [json objectForKey:@"spots"];
    if (parkingSpots != NULL) {
        [self populateMap];
    }
    else {
        NSLog(@"No available parking spots");
    }
}

- (void) populateMap
{
    for (NSDictionary* spot in parkingSpots) {
        NSArray *coordinates = [spot objectForKey:@"latlng"];
        CLLocationCoordinate2DMake([[coordinates objectAtIndex:0] doubleValue], [[coordinates objectAtIndex:1] doubleValue]);
        MapPin * pin = [[MapPin alloc] initWithCoord:CLLocationCoordinate2DMake([[coordinates objectAtIndex:0] doubleValue], [[coordinates objectAtIndex:1] doubleValue])
                                           andRating:5
                                             andRate:0.5
                                        andStartTime:2
                                          andEndTime:8];
        [worldView addAnnotation:pin];
    }
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{

}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [mapView setRegion:[mapView regionThatFits:region] animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if (annotation == mapView.userLocation) {
        return nil;
    }
    NSString * parkingSpotIdentifier = @"ParkingSpot"; // identifier used for parking spot pins, makes pins reusable to save memory
    
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:parkingSpotIdentifier];
    
    if (!pinView) {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:parkingSpotIdentifier];
        [pinView setPinColor:MKPinAnnotationColorGreen];
        pinView.animatesDrop = YES; // animates the pin dropping
        pinView.canShowCallout = YES; // can display a text bubble when tapped on
        
        UIImage *originalImage = [UIImage imageNamed:@"DJ.jpg"];
        CGSize destinationSize = CGSizeMake(40, 40);
        UIGraphicsBeginImageContext(destinationSize);
        [originalImage drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        UIImageView * hostPicture = [[UIImageView alloc] initWithImage:newImage];
        pinView.leftCalloutAccessoryView = hostPicture;
    }
    else {
        pinView.annotation = annotation;
    }
    
    return pinView;
}

- (NSArray *) parkingSpots {
    parkingSpots = _parkingSpots;
    return parkingSpots;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    // Tell the location manager to stop sending us messages
    [locationManager setDelegate:nil];
}

@end
