//
//  FavouriteMapPrice+CoreDataProperties.h
//  AirTickets
//
//  Created by Daniil Kniss on 04.07.2021.
//
//

#import "FavouriteMapPrice+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface FavouriteMapPrice (CoreDataProperties)

+ (NSFetchRequest<FavouriteMapPrice *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *destination;
@property (nullable, nonatomic, copy) NSString *origin;
@property (nullable, nonatomic, copy) NSDate *departure;
@property (nullable, nonatomic, copy) NSDate *returnDate;
@property (nonatomic) int16_t numberOfChanges;
@property (nonatomic) int32_t value;
@property (nonatomic) int32_t distance;
@property (nonatomic) BOOL actual;
@property (nullable, nonatomic, copy) NSDate *created;

@end

NS_ASSUME_NONNULL_END
