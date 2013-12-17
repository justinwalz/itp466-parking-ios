//
//  ReserveSpotController.m
//  parqV1
//
//  Created by Duncan Riefler on 12/11/13.
//  Copyright (c) 2013 Duncan Riefler. All rights reserved.
//

#import "ReserveSpotController.h"

@interface ReserveSpotController ()

@end

@implementation ReserveSpotController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        datePickerState = None;
    }
    return self;
}

- (id) initWithMapView: (MKMapView *) currentMapView {
    self = [super initWithNibName:@"ReserveSpotController" bundle:nil];
    if (self) {
        _parkingMapView = currentMapView;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"parq_logo_2.png"]];
    // Top Section
    [self setUserName:[self getUserName]];
    [self setRating:[self getRating]];
    [self setNumParkers:[self getNumParkers]];
    [self setProfilePic:[self getProfPic]];
    [self setDrivewayPic:[self getDrivewayPic]];
    // Middle Section
    [self setHoursAvailable:[self getHoursAvailable]];
    [self setHourlyRate:[self getHourlyRate]];
    [self setTheAddress:[self getAddress]];
    [self setParkingMapView:[self parkingMapView]];
    // Bottom Section
    [self setTotalPrice:[self getTotalPrice]];
    [self setTheStartTime:[self getStartTime]];
    [self setTheEndTime:[self getEndTime]];
}


// ------ TOP SECTION ------//
// User Name
- (NSString *) getUserName {
    return @"Jack";
}
- (void) setUserName:(NSString *) name {
    _nameLabel.text = name;
}

// Rating
- (int) getRating {
    return 5;
}
- (void) setRating:(int) rating {
    _ratingLabel.text = [NSString stringWithFormat:@"%d", rating];
}

// Number of parkers
- (int) getNumParkers {
    return 5;
}
- (void) setNumParkers:(int) numParkers {
    _numPrevParkers.text = [NSString stringWithFormat:@"%d", numParkers];
}

// Profile picture
- (NSString *) getProfPic {
    return @"DJ.jpg";
}
- (void) setProfilePic:(NSString *)profPic {
    [_ProfPic setImage:[UIImage imageNamed:profPic]];
}

// Driveway picture
- (NSString *) getDrivewayPic {
    return @"Driveway.jpg";
}
- (void) setDrivewayPic:(NSString *)parkingView {
    _parkingSpotView.image = [UIImage imageNamed:parkingView];
}

// ------ MIDDLE SECTION ------//

// Hours Available
- (NSString *) getHoursAvailable {
    return @"10am-6pm";
}

- (NSDate *) getStartHour {
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
    [components setHour:10];
    NSDate *today10am = [calendar dateFromComponents:components];
    return today10am;
}

- (NSDate *) getEndHour {
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
    [components setHour:18];
    NSDate *today6pm = [calendar dateFromComponents:components];
    return today6pm;
}

- (void) setHoursAvailable:(NSString *) hours {
    _numHours.text = hours;
}

// Hourly Rate
- (double) getHourlyRate {
    return 5.00;
}
- (void) setHourlyRate:(double) rate {
    _price.text = [NSString stringWithFormat:@"$%.02f",rate];
}

// Address
- (NSString *) getAddress {
    return @"707 W 28th Street, Los Angeles, CA, 90007";
}
- (void) setTheAddress:(NSString *) addr {
    _address.text = addr;
}

// ------ BOTTOM SECTION ------//
// Price
- (double) getTotalPrice {
    return 10.00;
}
- (void) setTotalPrice:(double) pr{
    _totalAmount.text = [NSString stringWithFormat:@"$%.02f",pr];
}

// Start Time
- (NSDate *) getStartTime {
    return [[NSDate alloc] init] ;
}
- (void) setTheStartTime:(NSDate *) date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    
    NSString *stringFromDate = [formatter stringFromDate:date];
    
    [_startTime setTitle:stringFromDate forState:UIControlStateNormal];
}

// End Time
- (NSDate *) getEndTime {
    return [[NSDate alloc] init] ;
}
- (void) setTheEndTime:(NSDate *) date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    
    NSString *stringFromDate = [formatter stringFromDate:date];
    
    [_endTime setTitle:stringFromDate forState:UIControlStateNormal];
}

// DATEPICKER STUFF

- (IBAction)startButtonPressed:(id)sender {
    datePickerState = Start;
    [self callDatePicker];
}

- (IBAction)endButtonPressed:(id)sender {
    datePickerState = End;
    [self callDatePicker];
}

- (void) callDatePicker
{
    if ([self.view viewWithTag:9]) {
        return;
    }
    CGRect toolbarTargetFrame = CGRectMake(0, self.view.bounds.size.height-216-44, 320, 44);
    CGRect datePickerTargetFrame = CGRectMake(0, self.view.bounds.size.height-216, 320, 216);
    
    UIView *darkView = [[UIView alloc] initWithFrame:self.view.bounds] ;
    darkView.alpha = 0;
    darkView.backgroundColor = [UIColor blackColor];
    darkView.tag = 9;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissDatePicker:)];
    [darkView addGestureRecognizer:tapGesture];
    [self.view addSubview:darkView];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height+44, 320, 216)];
    datePicker.backgroundColor = [UIColor lightGrayColor];
    [datePicker setDatePickerMode:UIDatePickerModeTime];
    [datePicker setMinuteInterval:30];
    [datePicker setMinimumDate:[self getStartHour]];
    [datePicker setMaximumDate:[self getEndHour]];
    datePicker.tag = 10;
    [datePicker addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datePicker];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, 320, 44)];
    toolBar.tag = 11;
    toolBar.barStyle = UIBarStyleDefault;
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] ;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissDatePicker:)] ;
    [toolBar setItems:[NSArray arrayWithObjects:doneButton, nil]];
//    [self.view addSubview:toolBar];
    
    [UIView beginAnimations:@"MoveIn" context:nil];
    toolBar.frame = toolbarTargetFrame;
    datePicker.frame = datePickerTargetFrame;
    darkView.alpha = 0.5;
    [UIView commitAnimations];
}

- (void)changeDate:(UIDatePicker *)sender {
    NSString * newTime = [NSString stringWithFormat:@"New Date: %@", sender.date];
    
    if (datePickerState == Start){
        [self setTheStartTime:sender.date];
//        [[self startTime] setTitle:newTime forState:UIControlStateNormal];
    }
    else if (datePickerState == End) {
        [self setTheEndTime:sender.date];
//        [[self endTime] setTitle:newTime forState:UIControlStateNormal];
    }
    
    // Calculate new price
    NSDate *start = [self getStartTime];
    NSDate *end = [self getEndTime];
    NSUInteger unitFlags = NSDayCalendarUnit;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:unitFlags fromDate:start toDate:end options:0];
    NSInteger hours = [components hour]/3600;
    NSLog(@"%ld",(long)hours);
    [self setTotalPrice:(int)hours];
}

- (void)removeViews:(id)object {
    [[self.view viewWithTag:9] removeFromSuperview];
    [[self.view viewWithTag:10] removeFromSuperview];
    [[self.view viewWithTag:11] removeFromSuperview];
}

- (void)dismissDatePicker:(id)sender {
    CGRect toolbarTargetFrame = CGRectMake(0, self.view.bounds.size.height, 320, 44);
    CGRect datePickerTargetFrame = CGRectMake(0, self.view.bounds.size.height+44, 320, 216);
    [UIView beginAnimations:@"MoveOut" context:nil];
    [self.view viewWithTag:9].alpha = 0;
    [self.view viewWithTag:10].frame = datePickerTargetFrame;
    [self.view viewWithTag:11].frame = toolbarTargetFrame;
    datePickerState = None;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeViews:)];
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
