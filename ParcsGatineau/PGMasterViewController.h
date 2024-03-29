//
//  PGMasterViewController.h
//  ParcsGatineau
//
//  Created by Philippe Casgrain on 12-03-25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PGDetailViewController;

#import <CoreData/CoreData.h>

@interface PGMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) PGDetailViewController *detailViewController;
@property (assign, nonatomic) BOOL filtered;

@property (strong, nonatomic) NSFetchedResultsController *currentFetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
