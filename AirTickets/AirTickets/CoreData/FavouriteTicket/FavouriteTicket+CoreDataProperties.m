//
//  FavouriteTicket+CoreDataProperties.m
//  AirTickets
//
//  Created by Daniil Kniss on 04.07.2021.
//
//

#import "FavouriteTicket+CoreDataProperties.h"

@implementation FavouriteTicket (CoreDataProperties)

+ (NSFetchRequest<FavouriteTicket *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"FavouriteTicket"];
}

@dynamic airline;
@dynamic created;
@dynamic departure;
@dynamic expires;
@dynamic flightNumber;
@dynamic from;
@dynamic price;
@dynamic returnDate;
@dynamic to;

@end
