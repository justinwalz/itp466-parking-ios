//
//  PQSignUpViewController.h
//  parqV1
//
//  Created by Duncan Riefler on 4/21/14.
//  Copyright (c) 2014 Duncan Riefler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface PQSignUpViewController : UIViewController <FBLoginViewDelegate>
@property (weak, nonatomic) IBOutlet FBLoginView *loginView;

@end
