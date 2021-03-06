//
//  Ticket.h
//  AirTickets
//
//  Created by Daniil Kniss on 24.06.2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Ticket : NSObject

@property (nonatomic) NSInteger price;
@property (nonatomic, strong) NSString *airline;
@property (nonatomic, strong) NSDate *departure;
@property (nonatomic, strong) NSDate *expires;
@property (nonatomic, strong) NSNumber *flightNumber;
@property (nonatomic, strong) NSDate *returnDate;
@property (nonatomic, strong) NSString *from;
@property (nonatomic, strong) NSString *to;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
