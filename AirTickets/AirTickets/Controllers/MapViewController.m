//
//  MapViewController.m
//  AirTickets
//
//  Created by Daniil Kniss on 27.06.2021.
//

#import "MapViewController.h"
#import "LocationService.h"
#import "APIManager.h"
#import "DataManager.h"
#import "MapPrice.h"
#import <CoreLocation/CoreLocation.h>
#import "CoreDataHelper.h"

@interface MapViewController ()

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) LocationService *locationService;
@property (nonatomic, strong) City *origin;
@property (nonatomic, strong) NSArray *prices;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Карта цен";
    
    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    [[DataManager sharedInstance] loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataLoadedSuccessfully) name:kDataManagerLoadDataDidComplete object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCurrentLocation:) name:kLocationServiceDidUpdateCurrentLocation object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dataLoadedSuccessfully {
    _locationService = [[LocationService alloc] init];
}

- (void)updateCurrentLocation:(NSNotification *)notification {
    CLLocation *currentLocation = notification.object;
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 1000000, 1000000);
    [_mapView setRegion:region animated:YES];
    
    if (currentLocation) {
        _origin = [[DataManager sharedInstance] cityForLocation: currentLocation];
        if (_origin) {
            [[APIManager sharedInstance] mapPricesFor:_origin withCompletion:^(NSArray * _Nonnull prices) {
                self.prices = prices;
            }];
        }
    }
}

- (void)setPrices:(NSArray *)prices {
    _prices = prices;
    [_mapView removeAnnotations:_mapView.annotations];
    
    for (MapPrice *price in prices) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MKPointAnnotation *annotation = [MKPointAnnotation new];
            annotation.title = [NSString stringWithFormat:@"%@ (%@)", price.destination.name, price.destination.code];
            annotation.subtitle = [NSString stringWithFormat:@"%ld руб.", (long)price.value];
            annotation.coordinate = price.destination.coordinate;
            [self->_mapView addAnnotation:annotation];
        });
    }
}


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Действия с направлением" message:@"Что необходимо сделать с выбранным направлением?" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *favouriteAction;
    MapPrice *selectedMapPrice;
  
    for (MapPrice *price in _prices) {
        NSString *formatedPriceName = [NSString stringWithFormat:@"%@ (%@)", price.destination.name, price.destination.code];
        if ([formatedPriceName isEqual:view.annotation.title]) {
            selectedMapPrice = price;
        }
    }

    if (selectedMapPrice) {
        if ([[CoreDataHelper sharedInstance] isFavouriteMapPrice:selectedMapPrice]) {
            favouriteAction = [UIAlertAction actionWithTitle:@"Удалить из избранного" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [[CoreDataHelper sharedInstance] removeMapPriceFromFavourite:selectedMapPrice];
            }];
        } else {
            favouriteAction = [UIAlertAction actionWithTitle:@"Добавить в избранное" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[CoreDataHelper sharedInstance] addMapPriceToFavourite:selectedMapPrice];
            }];
        }
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:favouriteAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

@end
