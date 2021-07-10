//
//  MapPrice.h
//  AirTickets
//
//  Created by Daniil Kniss on 27.06.2021.
//

#import <Foundation/Foundation.h>
#import "City.h"

NS_ASSUME_NONNULL_BEGIN

@interface MapPrice : NSObject
@property (nonatomic, strong) City *destination;
@property (nonatomic, strong) City *origin;
@property (nonatomic, strong) NSDate *departure;
@property (nonatomic, strong) NSDate *returnDate;
@property (nonatomic) NSInteger numberOfChanges;
@property (nonatomic) NSInteger value;
@property (nonatomic) NSInteger distance;
@property (nonatomic) BOOL actual;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary withOrigin: (City *)origin;

@end

NS_ASSUME_NONNULL_END
