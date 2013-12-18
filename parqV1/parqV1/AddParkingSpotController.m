//
//  AddParkingSpotController.m
//  parq
//
//  Created by Duncan Riefler on 11/14/13.
//  Copyright (c) 2013 Duncan Riefler. All rights reserved.
//

#import "AddParkingSpotController.h"
#define kLatestParkingSpotsURL [NSURL URLWithString:@"http://54.200.152.228:3000/add"] //2

@interface AddParkingSpotController ()

@end

@implementation AddParkingSpotController
@synthesize startTimePicker, endTimePicker, nameField, addressField, priceField, submitButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (IBAction)submitDataToServer:(id)sender;
{
    NSDictionary* info = [[NSDictionary alloc] initWithObjectsAndKeys:
                          nameField.text,@"name",
                          addressField.text, @"address",
                          priceField.text, @"price",
                          [self getStringFromDate:startTimePicker.date], @"startTime",
                          [self getStringFromDate:endTimePicker.date], @"endTime",
                          nil];
    
    NSError *error;
    
    //convert object to data
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:info 
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    if (jsonData) {
    NSLog(@"request sent");
    NSString *postLength = [NSString stringWithFormat:@"%d", [jsonData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:kLatestParkingSpotsURL];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jsonData];
    
    // generates an autoreleased NSURLConnection
    [NSURLConnection connectionWithRequest:request delegate:self];
    }
    else if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
}

- (NSString *) getStringFromDate: (NSDate *) date
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH"];
   return [dateFormatter stringFromDate:date];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"parq"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
