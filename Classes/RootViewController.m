//
//  RootViewController.m
//  Locations
//
//  Created by Tony Hillerson on 12/21/09.
//  Copyright 2009 EffectiveUI. All rights reserved.
//

#import "RootViewController.h"
#import "Event.h"

@implementation RootViewController

@synthesize eventsArray;
@synthesize managedObjectContext;
@synthesize addButton;
@synthesize locationManager;

#pragma mark -
#pragma mark Life and Death

- (void)dealloc {
	self.managedObjectContext = nil;
	[super dealloc];
}

- (void)viewDidUnload {
	self.locationManager = nil;
	self.eventsArray = nil;
	self.addButton = nil;
}

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

#pragma mark -
#pragma mark M methods

- (void) addEvent {
	CLLocation *location = [locationManager location];
	if (nil != location) {
		Event *event = (Event *)[NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:managedObjectContext];
		CLLocationCoordinate2D coordinate = location.coordinate;
		event.longitude = [NSNumber numberWithDouble:coordinate.longitude];
		event.latitude = [NSNumber numberWithDouble:coordinate.latitude];
		event.creationDate = [NSDate date];
		
		NSError *error;
		if (![managedObjectContext save:&error]) {
			// handle error
		} else {
			[eventsArray insertObject:event atIndex:0];
			NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
			[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			[self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
		}

	}
}

#pragma mark -
#pragma mark View methods

- (void) viewDidLoad {
	[super viewDidLoad];
	self.title = @"Locations";
	self.navigationItem.leftBarButtonItem = self.editButtonItem;
	
	self.addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addEvent)];
	self.addButton.enabled = NO;
	self.navigationItem.rightBarButtonItem = self.addButton;
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *ed = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:ed];
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:NO];
	NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];
	[sortDescriptor release];
	
	NSError *error;
	NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
	if (nil == mutableFetchResults) {
		// handle error
	}
	self.eventsArray = mutableFetchResults;

	[fetchRequest release];
	[mutableFetchResults release];
	
	[self.locationManager startUpdatingLocation];
}

#pragma mark -
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [eventsArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	// A date formatter for the time stamp
	static NSDateFormatter *dateFormatter = nil;
	if (dateFormatter == nil) {
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
		[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	}

	// A number formatter for the latitude and longitude
	
	static NSNumberFormatter *numberFormatter = nil;
	if (numberFormatter == nil) {
		numberFormatter = [[NSNumberFormatter alloc] init];
		[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
		[numberFormatter setMaximumFractionDigits:3];
	}
	
	static NSString *CellIdentifier = @"Cell";
    
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
      cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
  }
  
	Event *event = (Event *)[eventsArray objectAtIndex:indexPath.row];

	cell.textLabel.text = [dateFormatter stringFromDate:[event creationDate]];

	NSString *string = [NSString stringWithFormat:@"%@, %@",
											[numberFormatter stringFromNumber:[event latitude]],
											[numberFormatter stringFromNumber:[event longitude]]];

	cell.detailTextLabel.text = string;

	return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		NSManagedObject *eventToDelete = [eventsArray objectAtIndex:indexPath.row];
		[managedObjectContext deleteObject:eventToDelete];
		
		[eventsArray removeObjectAtIndex:indexPath.row];
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
		
		NSError *error;
		if (! [managedObjectContext save:&error]) {
			// handle error
		}
	}
}

#pragma mark -
#pragma mark Core Location Methods

// lazy creation
- (CLLocationManager *)locationManager {
	if (nil == locationManager) {
		locationManager = [[CLLocationManager alloc] init];
		locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
		locationManager.delegate = self;
	}
	return locationManager;
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
	addButton.enabled = YES;
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
	addButton.enabled = NO;
}



@end

