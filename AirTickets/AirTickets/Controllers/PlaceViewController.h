//
//  PlaceViewController.h
//  AirTickets
//
//  Created by Daniil Kniss on 24.06.2021.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum PlaceType {
    PlaceTypeArrival,
    PlaceTypeDeparture
} PlaceType;

@protocol PlaceViewControllerDelegate <NSObject>

-(void)selectPlace:(id)place withType:(PlaceType)placeType andDataType:(DataSourceType)dataType;

@end

@interface PlaceViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) id<PlaceViewControllerDelegate>delegate;

-(instancetype)initWithType:(PlaceType)type;

@end

NS_ASSUME_NONNULL_END
