//
//  Pin.h
//  parq
//
//  Created by Duncan Riefler on 10/18/13.
//  Copyright (c) 2013 Duncan Riefler. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface MapPin : NSObject<MKAnnotation>
{
    // rating out of 5 stars
    int _rating;
    // Hourly rate that seller is charging
    float _rate;
    // Times the spot is available
    int _startHour;
    int _endHour;
    CLPlacemark *_location;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString * title;
@property (nonatomic, readonly, copy) NSString * subtitle;
@property int UUID;

- (int) getUUID;
- (id)initWithCoord: (CLLocationCoordinate2D) coord andUUID: (int) uuid andName: (NSString *) nam andRating: (int)rating andRate: (float) rate andStartTime: (int) strt andEndTime: (int) end;

@end
