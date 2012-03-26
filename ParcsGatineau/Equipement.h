//
//  Equipement.h
//  ParcsGatineau
//
//  Created by Philippe Casgrain on 12-03-25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Equipement : NSManagedObject

@property (nonatomic, retain) NSString * nom;
@property (nonatomic, retain) NSManagedObject *parc;

@end
