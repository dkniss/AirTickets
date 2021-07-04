//
//  FavouriteMapPrice+CoreDataProperties.m
//  AirTickets
//
//  Created by Daniil Kniss on 04.07.2021.
//
//

#import "FavouriteMapPrice+CoreDataProperties.h"

@implementation FavouriteMapPrice (CoreDataProperties)

+ (NSFetchRequest<FavouriteMapPrice *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"FavouriteMapPrice"];
}

@dynamic destination;
@dynamic origin;
@dynamic departure;
@dynamic returnDate;
@dynamic numberOfChanges;
@dynamic value;
@dynamic distance;
@dynamic actual;
@dynamic created;

@end
