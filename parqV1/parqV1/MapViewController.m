//
//  MapViewController.m
//  parq
//
//  Created by Duncan Riefler on 10/28/13.
//  Copyright (c) 2013 Duncan Riefler. All rights reserved.
//

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1
#define kLatestParkingSpotsURL [NSURL URLWithString:@"http://54.201.140.112:3000/spots"] //2


#import "MapViewController.h"
#import "MapPin.h"
#import "AddParkingSpotController.h"
#import "ReserveSpotController.h"


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
        atUserLocation = false;
    }
    return self;
}

- (void)setUpNavBar
{

}

- (void)loadAddParkingSpotView
{
    // Pushes the next view where you can add a parking spot (button on top right)
    AddParkingSpotController *apsc = [[AddParkingSpotController alloc] initWithNibName:@"AddParkingSpotController" bundle:nil];
    [[self navigationController] pushViewController:apsc animated:YES];
}

- (IBAction)showUserLocation:(id)sender
{
    
    [self zoomToUserLocation:self.worldView.userLocation];
}

- (IBAction)findParking:(id)sender
{
    // Request parking spot data
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        kLatestParkingSpotsURL];
        if (data != nil) {
            [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:data waitUntilDone:YES];
        }
    });
    
    // HACK to put pins on map
//    MapPin * pin = [[MapPin alloc] initWithCoord:CLLocationCoordinate2DMake((double)34.1205,(double)-118.2856)
//                                       andRating:5
//                                         andRate:0.5
//                                    andStartTime:2
//                                      andEndTime:8];
//    [worldView addAnnotation:pin];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Map Stuff
    [self.worldView setDelegate:self];
    [self.worldView setShowsUserLocation:YES];
    [self.worldView setMapType:MKMapTypeStandard];
    
    // NavBar stuff
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"parq_logo_2.png"]];
    self.navigationItem.titleView.layer.frame = CGRectMake(50, 0, 125, 84);
    self.navigationItem.titleView.layer.masksToBounds = NO;
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"texture3.jpg"]forBarMetrics:UIBarMetricsDefault];
    
    // Right Button
    UIImage* image3 = [UIImage imageNamed:@"icon-garage1.png"];
    CGRect frameimg = CGRectMake(0, 0, 35, 35);
    UIButton* someButton = [[UIButton alloc] initWithFrame:frameimg];
    [someButton setBackgroundImage:image3 forState:UIControlStateNormal];
    [someButton addTarget:self action:@selector(loadAddParkingSpotView)
         forControlEvents:UIControlEventTouchUpInside];
    [someButton setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:someButton];
    [[self navigationItem] setRightBarButtonItem:barButton];
    [someButton.layer setZPosition:2];
    
    // Arrow Button
    
    _userLocationButton.layer.cornerRadius = 3.0f;
    _userLocationButton.layer.shadowRadius = 3.0f;
    _userLocationButton.layer.shadowColor = [UIColor blackColor].CGColor;
    _userLocationButton.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    _userLocationButton.layer.shadowOpacity = 0.5f;
    _userLocationButton.layer.masksToBounds = NO;
    
    // Search Bar button
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    
    // Find Parking Button
    // Add corner radius
    self.findParkingButton.layer.cornerRadius = 4.0f;
    self.findParkingButton.layer.masksToBounds = NO;

    // Create the colors
    UIColor *color1 =
    [UIColor colorWithRed:(float)62/255 green:(float)177/255 blue:(float)213/255 alpha:1.0];
    UIColor *color2 =
    [UIColor colorWithRed:(float)72/255 green:(float)200/255 blue:(float)222/255 alpha:1.0];
    UIColor *color3 =
    [UIColor colorWithRed:(float)72/255 green:(float)200/255 blue:(float)222/255 alpha:1.0];
    UIColor *color4 =
    [UIColor colorWithRed:(float)72/255 green:(float)200/255 blue:(float)222/255 alpha:1.0];
    UIColor *color5 =
    [UIColor colorWithRed:(float)62/255 green:(float)177/255 blue:(float)213/255 alpha:1.0];
    
    // Create the gradient
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    // Set colors
    gradient.colors = [NSArray arrayWithObjects:
                       (id)color1.CGColor,
                       (id)color2.CGColor,
                       (id)color3.CGColor,
                       (id)color4.CGColor,
                       (id)color5.CGColor,
                       nil];
    
    // Set bounds
    gradient.frame = self.findParkingButton.bounds;
    gradient.cornerRadius = 4.0f;
    
    // Add the gradient to the view
    [self.findParkingButton.layer insertSublayer:gradient atIndex:0];
    
    // Bottom view
    UIImage *background =[UIImage imageNamed:@"texture3.jpg"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:background];
    [_bottomView addSubview:imageView];
    [_bottomView sendSubviewToBack:imageView ];

}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self zoomToUserLocation:self.worldView.userLocation];
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
        NSArray *price = [spot objectForKey:@"price"];
        NSArray *startTime = [spot objectForKey:@"startTime"];
        NSArray *endTime = [spot objectForKey:@"endTime"];


        CLLocationCoordinate2DMake([[coordinates objectAtIndex:0] doubleValue], [[coordinates objectAtIndex:1] doubleValue]);
        MapPin * pin = [[MapPin alloc] initWithCoord:CLLocationCoordinate2DMake([[coordinates objectAtIndex:0] doubleValue], [[coordinates objectAtIndex:1] doubleValue])
                                           andRating:5
                                             andRate:[[price objectAtIndex:0] intValue]
                                        andStartTime:[[startTime objectAtIndex:0] intValue]
                                          andEndTime:[[endTime objectAtIndex:0] intValue]];
        [worldView addAnnotation:pin];
    }
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (atUserLocation == false) {
        [self zoomToUserLocation:userLocation];
        atUserLocation = true;
    }
}


- (void)zoomToUserLocation:(MKUserLocation *)userLocation
{
    if (!userLocation)
        return;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 800, 800);
    [self.worldView setRegion:region animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    // If the pin is on the users location, don't display it
    if (annotation == mapView.userLocation) {
        return nil;
    }
    NSString * parkingSpotIdentifier = @"ParkingSpot"; // identifier used for parking spot pins, makes pins reusable to save memory
    
    // The view that will be displayed when a user taps on a pin
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:parkingSpotIdentifier];
    

    if (!pinView) {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:parkingSpotIdentifier];
        [pinView setPinColor:MKPinAnnotationColorGreen];
        pinView.animatesDrop = YES; // animates the pin dropping
        pinView.canShowCallout = YES; // can display a text bubble when tapped on
        
        // Setting the image to be an image of me hehe
        UIImage *originalImage = [UIImage imageNamed:@"DJ.jpg"];
        CGSize destinationSize = CGSizeMake(40, 40);
        UIGraphicsBeginImageContext(destinationSize);
        [originalImage drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        // Adding the image as the left item on the pin bubble
        UIImageView * hostPicture = [[UIImageView alloc] initWithImage:newImage];
        pinView.leftCalloutAccessoryView = hostPicture;
        
        // Add a button as the right item on the pin bubble
        UIButton * moreButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [moreButton addTarget:self action:@selector(loadReserveSpotView) forControlEvents:UIControlEventTouchUpInside];
        pinView.rightCalloutAccessoryView = moreButton;
    }
    else {
        pinView.annotation = annotation;
    }
    
    return pinView;
}

- (void) loadReserveSpotView
{
    // Pushes the next view where you can add a parking spot (button on top right)
    ReserveSpotController *rsc = [[ReserveSpotController alloc] initWithMapView:worldView];
    rsc.modalTransitionStyle = UIModalTransitionStyleCoverVertical ;
    [[self navigationController] pushViewController:rsc animated:YES];
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
