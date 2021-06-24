//
//  TicketsViewController.h
//  AirTickets
//
//  Created by Daniil Kniss on 24.06.2021.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TicketsViewController : UITableViewController

- (instancetype)initWithTickets:(NSArray *)tickets;

@end

NS_ASSUME_NONNULL_END
