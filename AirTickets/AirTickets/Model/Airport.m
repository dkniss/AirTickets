//
//  Airport.m
//  AirTickets
//
//  Created by Daniil Kniss on 24.06.2021.
//

#import "Airport.h"

@implementation Airport

- (instancetype) initWithDictionary: (NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        _translations = [dictionary valueForKey:@"name_translations"];
        _name = [dictionary valueForKey:@"name"];
        _code = [dictionary valueForKey:@"code"];
        _timeZone = [dictionary valueForKey:@"time_zone"];
        _countryCode = [dictionary valueForKey:@"country_code"];
        _cityCode = [dictionary valueForKey:@"city_code"];
        _flightable = [dictionary valueForKey:@"flightable"];
        
        NSDictionary *coords = [dictionary valueForKey:@"coordinates"];
        if (coords && ![coords isEqual:[NSNull null]]) {
            NSNumber *lon = [coords valueForKey: @"lon"];
            NSNumber *lat = [coords valueForKey: @"lat"];
            if (![lon isEqual:[NSNull null]] && ![lat isEqual:[NSNull null]]) {
                _coordinate = CLLocationCoordinate2DMake([lat doubleValue], [lon doubleValue]);
            }
        }
    }
    return self;
}

@end
