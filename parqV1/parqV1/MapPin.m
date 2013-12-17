//
//  Pin.m
//  parq
//
//  Created by Duncan Riefler on 10/18/13.
//  Copyright (c) 2013 Duncan Riefler. All rights reserved.
//

#import "MapPin.h"

@implementation MapPin
@synthesize coordinate, title, UUID;

// Test to see if works with just a coordinate
- (id)initWithCoord: (CLLocationCoordinate2D) coord andUUID: (int) uuid andName: (NSString *) nam andRating: (int)rating andRate: (float) rate andStartTime: (int) strt andEndTime: (int) end
{
    self = [super init];
    if (self) {
        _rating = rating;
        _rate = rate;
        _startHour = strt;
        _endHour = end;
        UUID = uuid;
        coordinate = coord;
        title = [NSString stringWithFormat: @"%@ - $%.02f", nam, rate];
        _subtitle = [NSString stringWithFormat:@"Hours: %d:00 - %d:00", strt, end];
    }
    return self;
}

- (int) getUUID
{
    return UUID;
}
@end
