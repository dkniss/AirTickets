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
#import "FavouriteTicket+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface CoreDataHelper : NSObject

+ (instancetype)sharedInstance;

- (BOOL)isFavourite:(Ticket *)ticket;
- (NSArray *)favourites;
- (void)addToFavourite:(Ticket *)ticket;
- (void)removeFromFavourite:(Ticket *)ticket;

@end

NS_ASSUME_NONNULL_END
