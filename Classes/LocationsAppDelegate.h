//
//  LocationsAppDelegate.h
//  Locations
//
//  Created by Tony Hillerson on 12/21/09.
//  Copyright EffectiveUI 2009. All rights reserved.
//

@interface LocationsAppDelegate : NSObject <UIApplicationDelegate> {

  NSManagedObjectModel *managedObjectModel;
  NSManagedObjectContext *managedObjectContext;	    
  NSPersistentStoreCoordinator *persistentStoreCoordinator;
	
	UINavigationController *navigationController;

  UIWindow *window;
}

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, retain) UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet UIWindow *window;

- (NSString *)applicationDocumentsDirectory;
- (IBAction) saveAction:sender;

@end

