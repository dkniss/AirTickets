//
//  TabBarController.m
//  AirTickets
//
//  Created by Daniil Kniss on 03.07.2021.
//

#import "TabBarController.h"
#import "MainViewController.h"
#import "MapViewController.h"
#import "TicketsViewController.h"

@interface TabBarController ()

@end

@implementation TabBarController

-(instancetype)init {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.viewControllers = [self createViewControllers];
        self.tabBar.barTintColor = [UIColor systemBlueColor];
        self.tabBar.tintColor = [UIColor whiteColor];
        self.tabBar.unselectedItemTintColor = [UIColor lightGrayColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(NSArray<UIViewController*> *)createViewControllers {
    NSMutableArray<UIViewController*> *controllers = [NSMutableArray new];
    
    MainViewController *mainViewController = [[MainViewController alloc] init];
    mainViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Поиск" image:[UIImage systemImageNamed:@"ticket"] selectedImage:[UIImage systemImageNamed:@"ticket.fill"]];
    UINavigationController *mainNavigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    [controllers addObject:mainNavigationController];
    
    MapViewController *mapViewController = [[MapViewController alloc] init];
    mapViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Карта цен" image:[UIImage systemImageNamed:@"map"] selectedImage:[UIImage systemImageNamed:@"map.fill"]];
    UINavigationController *mapNavigationController = [[UINavigationController alloc] initWithRootViewController:mapViewController];
    [controllers addObject:mapNavigationController];
    
    TicketsViewController *favouriteViewController = [[TicketsViewController alloc] initFavouriteTicketsController];
        favouriteViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Избранное" image:[UIImage systemImageNamed:@"star"] selectedImage:[UIImage systemImageNamed:@"star.fill"]];
        UINavigationController *favoriteNavigationController = [[UINavigationController alloc] initWithRootViewController:favouriteViewController];
        [controllers addObject:favoriteNavigationController];

    return controllers;
}



@end
