//
//  City.m
//  AirTickets
//
//  Created by Daniil Kniss on 24.06.2021.
//

#import "City.h"

@implementation City

- (instancetype) initWithDictionary: (NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        _translations = [dictionary valueForKey:@"name_translations"];
        _name = [dictionary valueForKey:@"name"];
        _code = [dictionary valueForKey:@"code"];
        _timeZone = [dictionary valueForKey:@"time_zone"];
        _countryCode = [dictionary valueForKey:@"country_code"];
        
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
