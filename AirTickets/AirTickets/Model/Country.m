//
//  Country.m
//  AirTickets
//
//  Created by Daniil Kniss on 24.06.2021.
//

#import "Country.h"

@implementation Country

- (instancetype) initWithDictionary: (NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        self.currency = [dictionary valueForKey:@"currency"];
        _translations = [dictionary valueForKey:@"name_translations"];
        _name = [dictionary valueForKey:@"name"];
        _code = [dictionary valueForKey:@"code"];
     }
    return self;
}

@end
