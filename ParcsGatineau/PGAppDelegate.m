//
//  PGAppDelegate.m
//  ParcsGatineau
//
//  Created by Philippe Casgrain on 12-03-25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PGAppDelegate.h"

#import "PGMasterViewController.h"
#import "Parc.h"
#import "Equipement.h"

@implementation PGAppDelegate

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize navigationController = _navigationController;

- (void)loadParks
{
    NSArray *parcsSrc = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Parcs" ofType:@"plist"]];
    NSArray *equipementSrc = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Equipements" ofType:@"plist"]];

    NSMutableArray *parcs = [NSMutableArray arrayWithCapacity:[parcsSrc count]];

    for (NSDictionary *unParc in parcsSrc)
    {
        Parc *parc = [NSEntityDescription insertNewObjectForEntityForName:@"Parc" inManagedObjectContext:self.managedObjectContext];
        
        parc.nom = [unParc valueForKey:@"nom"];
        parc.secteur = [unParc valueForKey:@"secteur"];
        parc.adresse = [unParc valueForKey:@"adresse"];
        parc.latitude = [unParc valueForKey:@"latitude"];
        parc.longitude = [unParc valueForKey:@"longitude"];

        [parcs addObject:parc];
    }

    NSMutableArray *equipements = [NSMutableArray arrayWithCapacity:[parcs count]];
    for (NSInteger i = 0; i < [parcs count]; i++)
    {
        NSMutableSet *s = [NSMutableSet setWithCapacity:0];
        [equipements addObject:s];
    }

    for (NSDictionary *unEquipement in equipementSrc)
    {
        Equipement *e = [NSEntityDescription insertNewObjectForEntityForName:@"Equipement" inManagedObjectContext:self.managedObjectContext];
        e.nom = [unEquipement valueForKey:@"installation"];
        NSInteger identifiant_parc = [[unEquipement valueForKey:@"identifiant_parc"] intValue];
        NSAssert(identifiant_parc > 0, @"identifiant_parc ne peux être < 0: %d", identifiant_parc);
        NSAssert(identifiant_parc <= [equipements count], @"identifiant_parc ne peux être > %d: %d", [equipements count], identifiant_parc);
        NSMutableSet *s = [equipements objectAtIndex:identifiant_parc - 1];
        [s addObject:e];
    }

    for (NSInteger i = 0; i < [equipements count]; i++)
    {
        Parc *p = [parcs objectAtIndex:i];
        NSMutableSet *s = [equipements objectAtIndex:i];
        p.equipements = s;
    }

    NSError *error;
    if (![self.managedObjectContext save:&error])
        NSLog(@"Erreur! %@", [error description]);
}

- (void)printParks
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Parc" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];

    NSError *error = nil;
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (array == nil)
    {
        NSLog(@"Erreur! %@", [error description]);
        return;
    }
    for (id obj in array)
        NSLog(@"%@", [obj description]);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    [self loadParks];
    [self printParks];

    PGMasterViewController *masterViewController = [[PGMasterViewController alloc] initWithNibName:@"PGMasterViewController" bundle:nil];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
    masterViewController.managedObjectContext = self.managedObjectContext;
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ParcsGatineau" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ParcsGatineau.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
