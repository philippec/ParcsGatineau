//
//  Parc.h
//  ParcsGatineau
//
//  Created by Philippe Casgrain on 12-03-25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Equipement;

@interface Parc : NSManagedObject

@property (nonatomic, retain) NSString * secteur;
@property (nonatomic, retain) NSString * nom;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSString * adresse;
@property (nonatomic, retain) NSSet *equipements;
@end

@interface Parc (CoreDataGeneratedAccessors)

- (void)addEquipementsObject:(Equipement *)value;
- (void)removeEquipementsObject:(Equipement *)value;
- (void)addEquipements:(NSSet *)values;
- (void)removeEquipements:(NSSet *)values;

+ (NSFetchedResultsController *)fetchedResultsControllerBySector:(NSManagedObjectContext *)context;
+ (NSFetchedResultsController *)fetchedResultsControllerBySector:(NSManagedObjectContext *)context forEquipement:(NSString *)equipmentName;

@end
