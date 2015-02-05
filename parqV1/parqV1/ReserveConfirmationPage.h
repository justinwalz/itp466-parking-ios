//
//  ReserveConfirmationPage.h
//  parqV1
//
//  Created by Duncan Riefler on 3/5/14.
//  Copyright (c) 2014 Duncan Riefler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReserveConfirmationPage : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *startHour;
@property (weak, nonatomic) IBOutlet UILabel *endHour;

- (IBAction)getDirectionsPressed:(id)sender;

@end
