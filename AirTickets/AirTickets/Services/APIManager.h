//
//  APIManager.h
//  AirTickets
//
//  Created by Daniil Kniss on 24.06.2021.
//

#import <Foundation/Foundation.h>
#import "DataManager.h"
#import "City.h"
#import "Ticket.h"


#define API_TOKEN @"a0d185479b665d5054fc5ff21bb88821"
#define API_URL_IP_ADDRESS @"https://api.ipify.org/?format=json"
#define API_URL_CHEAP @"https://api.travelpayouts.com/v1/prices/cheap"
#define API_URL_CITY_FROM_IP @"https://www.travelpayouts.com/whereami?ip="


NS_ASSUME_NONNULL_BEGIN

@interface APIManager : NSObject

+ (instancetype)sharedInstance;

- (void)cityForCurrentIP:(void (^)(City *city))completion;

- (void)ticketsWithRequest:(SearchRequest)request withCompletion:(void (^)(NSArray *tickets))completion;

- (void)load:(NSString *)urlString withCompletion:(void (^)(id _Nullable result))completion;

@end

NS_ASSUME_NONNULL_END
