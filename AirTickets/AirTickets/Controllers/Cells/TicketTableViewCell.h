//
//  TicketTableViewCell.h
//  AirTickets
//
//  Created by Daniil Kniss on 24.06.2021.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "APIManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface TicketTableViewCell : UITableViewCell

@property (nonatomic, strong) Ticket *ticket;

@end

NS_ASSUME_NONNULL_END
