//
//  CoreDataHelper.h
//  AirTickets
//
//  Created by Daniil Kniss on 04.07.2021.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DataManager.h"
#import "Ticket.h"
#import "MapPrice.h"
#import "FavouriteTicket+CoreDataClass.h"
#import "FavouriteMapPrice+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface CoreDataHelper : NSObject

+ (instancetype)sharedInstance;

- (BOOL)isFavouriteTicket:(Ticket *)ticket;
- (NSArray *)favouriteTickets;
- (void)addTicketToFavourite:(Ticket *)ticket;
- (void)removeTicketFromFavourite:(Ticket *)ticket;

- (BOOL)isFavouriteMapPrice:(MapPrice *)mapPrice;
- (NSArray *)favouriteMapPrices;
- (void)addMapPriceToFavourite:(MapPrice *)mapPrice;
- (void)removeMapPriceFromFavourite:(MapPrice *)mapPrice;

@end

NS_ASSUME_NONNULL_END
