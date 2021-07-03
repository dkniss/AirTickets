//
//  SceneDelegate.m
//  AirTickets
//
//  Created by Daniil Kniss on 24.06.2021.
//

#import "SceneDelegate.h"
#import "MainViewController.h"
#import "MapViewController.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    CGRect windowFrame = [[UIScreen mainScreen] bounds];
    self.window = [[UIWindow alloc] initWithFrame:windowFrame];
    [self.window makeKeyAndVisible];
    
    MapViewController *mapViewController = [MapViewController new];
    MainViewController *mainViewController = [MainViewController new];
    UITabBarController *tabBarController = [UITabBarController new];
    UITabBarItem *item1 = [[UITabBarItem alloc] initWithTitle:@"Поиск" image:[UIImage systemImageNamed:@"ticket.fill"]  tag:0];
    UITabBarItem *item2 = [[UITabBarItem alloc] initWithTitle:@"Карта" image:[UIImage systemImageNamed:@"map.fill"]  tag:1];
    mainViewController.tabBarItem  = item1;
    mapViewController.tabBarItem = item2;
    NSArray *viewControllers = [NSArray arrayWithObjects:mainViewController, mapViewController, nil];
    [tabBarController setViewControllers:viewControllers];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tabBarController];
    
    self.window.rootViewController = navigationController;
    UIWindowScene *windowScene = (UIWindowScene *)scene;
    [self.window setWindowScene:windowScene];
}


- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}


@end
