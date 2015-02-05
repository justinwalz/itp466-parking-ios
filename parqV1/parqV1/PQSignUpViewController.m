//
//  PQSignUpViewController.m
//  parqV1
//
//  Created by Duncan Riefler on 4/21/14.
//  Copyright (c) 2014 Duncan Riefler. All rights reserved.
//

#import "PQSignUpViewController.h"

@interface PQSignUpViewController ()

@end

@implementation PQSignUpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
//    self.profilePictureView.profileID = user.id;
//    self.nameLabel.text = user.name;
    
    // CREATE A NEW PARQ USER HERE
    // Create an instance of a PQUser and set their first name, last name, and email.
    
    // EXIT PAGE
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.loginView.readPermissions = @[@"basic_info", @"email"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
