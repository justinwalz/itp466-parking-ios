//
//  SearchViewController.h
//  parqV1
//
//  Created by Duncan Riefler on 12/19/13.
//  Copyright (c) 2013 Duncan Riefler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MapViewController.h"

@interface SearchViewController : UIViewController <UISearchBarDelegate, UISearchDisplayDelegate>
{
    NSArray *searchResults;
    MapViewController *mapViewController;
}
@property (weak, nonatomic) UISearchBar *searchBar;

- (id) initWithMapViewController: (MapViewController *) mvc;

@end
