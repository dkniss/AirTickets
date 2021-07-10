//
//  CoreDataHelper.m
//  AirTickets
//
//  Created by Daniil Kniss on 04.07.2021.
//

#import "CoreDataHelper.h"

@interface CoreDataHelper()
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@end

@implementation CoreDataHelper

+ (instancetype)sharedInstance {
    static CoreDataHelper *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CoreDataHelper alloc] init];
        [instance setup];
    });
    return instance;
}

- (void)setup {
    //Managed Object Model
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DataModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    //Persistant Store Coordinator
    NSURL *docsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [docsURL URLByAppendingPathComponent:@"base.sqlite"];
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
    
    NSPersistentStore *store = [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:nil];
    if (!store) {
        abort();
    }
    
    //Managed Object Context
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _managedObjectContext.persistentStoreCoordinator = _persistentStoreCoordinator;
}

- (void)save {
    NSError *error;
    [_managedObjectContext save:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
}
//Favourite Ticket
- (FavouriteTicket *)favouriteFromTicket:(Ticket *)ticket {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"FavouriteTicket"];
    request.predicate = [NSPredicate predicateWithFormat:@"price == %ld AND airline == %@ AND from == %@ AND to == %@ AND departure == %@ AND expires == %@ AND flightNumber == %ld",(long)ticket.price, ticket.airline, ticket.from, ticket.to, ticket.departure, ticket.expires, (long)ticket.flightNumber.integerValue];
    return [[_managedObjectContext executeFetchRequest:request error:nil] firstObject];
}

- (BOOL)isFavouriteTicket:(Ticket *)ticket {
    return [self favouriteFromTicket:ticket] != nil;
}

- (void)addTicketToFavourite:(Ticket *)ticket {
    FavouriteTicket *favourite = [NSEntityDescription insertNewObjectForEntityForName:@"FavouriteTicket" inManagedObjectContext:_managedObjectContext];
    favourite.price = ticket.price;
    favourite.airline = ticket.airline;
    favourite.departure = ticket.departure;
    favourite.expires = ticket.expires;
    favourite.flightNumber = ticket.flightNumber.intValue;
    favourite.returnDate = ticket.returnDate;
    favourite.from = ticket.from;
    favourite.to = ticket.to;
    favourite.created = [NSDate date];
    
    [self save];
}

- (void)removeTicketFromFavourite:(Ticket *)ticket {
    FavouriteTicket *favourite = [self favouriteFromTicket:ticket];
    if (favourite) {
        [_managedObjectContext deleteObject:favourite];
        [self save];
    }
}

- (NSArray *)favouriteTickets {
    NSFetchRequest *request = [NSFetchRequest  fetchRequestWithEntityName:@"FavouriteTicket"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"created" ascending:NO]];
    return [_managedObjectContext executeFetchRequest:request error:nil];
}

//Favourite Map Price
- (FavouriteMapPrice *)favouriteFromMapPrice:(MapPrice *)mapPrice {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"FavouriteMapPrice"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"destination == %@", mapPrice.destination.name];
    
    return [[_managedObjectContext executeFetchRequest:request error:nil] firstObject];
}

- (BOOL)isFavouriteMapPrice:(MapPrice *)mapPrice {
    return [self favouriteFromMapPrice:mapPrice] != nil;
}

- (void)addMapPriceToFavourite:(MapPrice *)mapPrice {
    FavouriteMapPrice *favourite = [NSEntityDescription insertNewObjectForEntityForName:@"FavouriteMapPrice" inManagedObjectContext:_managedObjectContext];
    favourite.destination = mapPrice.destination.name;
    favourite.origin = mapPrice.origin.name;
    favourite.departure = mapPrice.departure;
    favourite.returnDate = mapPrice.returnDate;
    favourite.numberOfChanges = (int)mapPrice.numberOfChanges;
    favourite.value = (int)mapPrice.value;
    favourite.distance = (int)mapPrice.distance;
    favourite.actual = mapPrice.actual;
    favourite.created = [NSDate date];

    [self save];
}

- (void)removeMapPriceFromFavourite:(MapPrice *)mapPrice {
    FavouriteMapPrice *favourite = [self favouriteFromMapPrice:mapPrice];
    if (favourite) {
        [_managedObjectContext deleteObject:favourite];
        [self save];
    }
}

- (NSArray *)favouriteMapPrices {
    NSFetchRequest *request = [NSFetchRequest  fetchRequestWithEntityName:@"FavouriteMapPrice"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"created" ascending:NO]];
    return [_managedObjectContext executeFetchRequest:request error:nil];
}

@end
