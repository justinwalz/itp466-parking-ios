//
//  PQUser.h
//  parqV1
//
//  Created by Duncan Riefler on 4/21/14.
//  Copyright (c) 2014 Duncan Riefler. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PQUser : NSObject
@property NSString * name;
@property NSString * email;
@property NSString * password;
@property NSString * UUID;
@property float rating;
@property NSMutableArray * reservedSpots;
@property NSMutableArray * ownedSpots;

@end
