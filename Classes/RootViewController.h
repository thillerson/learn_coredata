//
//  RootViewController.h
//  Locations
//
//  Created by Tony Hillerson on 12/21/09.
//  Copyright 2009 EffectiveUI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Event.h"

@interface RootViewController : UITableViewController<CLLocationManagerDelegate> {
	NSMutableArray *eventsArray;
	NSManagedObjectContext *managedObjectContext;
	CLLocationManager *locationManager;
	UIBarButtonItem *addButton;
}

@property (nonatomic, retain) NSMutableArray *eventsArray;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) UIBarButtonItem *addButton;

- (void) addEvent;

@end
