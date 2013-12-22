//
//  SearchViewControllerNew.m
//  parqV1
//
//  Created by Duncan Riefler on 12/21/13.
//  Copyright (c) 2013 Duncan Riefler. All rights reserved.
//


#import "SearchViewControllerNew.h"

@interface SearchViewControllerNew ()

@end

@implementation SearchViewControllerNew

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (id) initWithMapViewController: (MapViewController *) mvc
{
    self = [super initWithNibName:@"SearchViewControllerNew" bundle:nil];
    if (self) {
        mapViewController = mvc;
    }
    return self;
}

- (void) viewDidAppear:(BOOL)animated
{
    [_searchBar becomeFirstResponder];
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.searchDisplayController setDelegate:self];
    [_searchBar setDelegate:self];
    
    // Adjust position of view to fix a bug
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.searchDisplayController.displaysSearchBarInNavigationBar = YES;
    
    // Get rid of back button
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
    // Add cancel button as right item of nav bar
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                  target:self
                                  action:@selector(dismissController)];
    [[self navigationItem] setRightBarButtonItem:barButton];
}

/***********************
 SEARCH DELEGATE METHODS
 ************************/
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    //    [searchBar setShowsCancelButton:YES animated:YES];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    // Make a request that returns an array of locations in the area that include the searchString
    // The table will then be populated with these items
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = searchString;
    request.region = mapViewController.worldView.region;
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        if (response.mapItems.count == 0)
            NSLog(@"No Matches");
        else {
            searchResults = response.mapItems;
            [self.searchDisplayController.searchResultsTableView reloadData];
        }
    }];
    return YES;
}


/***********************
 TABLE VIEW METHODS
 ************************/
// Determines number of rows in the table. If there
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (searchResults) {
        return [searchResults count];
        
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"AddressCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    MKMapItem *item = [searchResults objectAtIndex:indexPath.row];
    
    cell.textLabel.text = item.name;
    cell.detailTextLabel.text = item.placemark.addressDictionary[@"Street"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Create a mapItem from the chosen result
    MKMapItem *item = [searchResults objectAtIndex:indexPath.row];
    // set the searchBar text on the MapViewController to the address of the chosen place
    [[mapViewController searchBar] setText:item.name];
    
    // Dismiss the search view controller
    [self dismissController];
    // get all the parking spots in that area and display them on the map (probably send a message to the server to ask for that data)
    
}

/***********************
 END CONTROLLER METHODS
 ************************/
- (void) dismissController
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromBottom;
    [self.navigationController.view.layer addAnimation:transition
                                                forKey:kCATransition];
    [self.navigationController popViewControllerAnimated:NO];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
