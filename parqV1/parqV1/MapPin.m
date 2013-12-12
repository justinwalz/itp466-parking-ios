//
//  Pin.m
//  parq
//
//  Created by Duncan Riefler on 10/18/13.
//  Copyright (c) 2013 Duncan Riefler. All rights reserved.
//

#import "MapPin.h"

@implementation MapPin
@synthesize coordinate, title;

- (id)initWithLocation: (CLPlacemark *) loc andRating: (int)rating andRate: (float) rate andStartTime: (int) strt andEndTime: (int) end
{
    self = [super init];
    if (self) {
        _location = loc;
        _rating = rating;
        _rate = rate;
        _startHour = strt;
        _endHour = end;
        coordinate = [[loc location] coordinate];
    }
    return self;
}

// Test to see if works with just a coordinate
- (id)initWithCoord: (CLLocationCoordinate2D) coord andRating: (int)rating andRate: (float) rate andStartTime: (int) strt andEndTime: (int) end
{
    self = [super init];
    if (self) {
        _rating = rating;
        _rate = rate;
        _startHour = strt;
        _endHour = end;
        coordinate = coord;
        title = @"Goku's house";
    }
    return self;
}
@end
