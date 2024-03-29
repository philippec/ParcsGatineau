//
//  Parc.m
//  ParcsGatineau
//
//  Created by Philippe Casgrain on 12-03-25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Parc.h"
#import "Equipement.h"


@implementation Parc

@dynamic secteur;
@dynamic nom;
@dynamic longitude;
@dynamic latitude;
@dynamic adresse;
@dynamic equipements;

+ (NSFetchRequest *)fetchRequestBySectorAndName:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Parc" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"secteur" ascending:YES];
    NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"nom" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nameDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];

    return fetchRequest;
}

+ (NSFetchedResultsController *)fetchedResultsControllerBySector:(NSManagedObjectContext *)context
{    
    NSFetchRequest *fetchRequest = [Parc fetchRequestBySectorAndName:context];

    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:@"secteur" cacheName:nil];
    
	NSError *error = nil;
	if (![aFetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return aFetchedResultsController;
}

+ (NSFetchedResultsController *)fetchedResultsControllerBySector:(NSManagedObjectContext *)context forEquipement:(NSString *)equipmentName
{
    NSFetchRequest *fetchRequest = [Parc fetchRequestBySectorAndName:context];

    NSPredicate *equipmentPredicate = [NSPredicate predicateWithFormat:@"equipements.nom CONTAINS %@", equipmentName];
    fetchRequest.predicate = equipmentPredicate;
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:@"secteur" cacheName:nil];
    
	NSError *error = nil;
	if (![aFetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return aFetchedResultsController;
}


@end
