//
//  TicketsViewController.m
//  AirTickets
//
//  Created by Daniil Kniss on 24.06.2021.
//

#import "TicketsViewController.h"
#import "TicketTableViewCell.h"
#import "CoreDataHelper.h"
#import "NotificationCenter.h"

#define TicketCellReuseIdentifier @"TicketCellIdentifier"

@interface TicketsViewController ()
@property (nonatomic, strong) NSArray *tickets;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UITextField *dateTextField;
@end

@implementation TicketsViewController {
    BOOL isFavourites;
    BOOL sortedByAscending;
    TicketTableViewCell *notificationCell;
}

- (instancetype)initWithTickets:(NSArray *)tickets {
    self = [super init];
    if (self)
    {
        _tickets = tickets;
        self.title = @"Билеты";
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:[TicketTableViewCell class] forCellReuseIdentifier:TicketCellReuseIdentifier];
        
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        _datePicker.minimumDate = [NSDate date];
        
        _dateTextField = [[UITextField alloc] initWithFrame:self.view.bounds];
        _dateTextField.hidden = YES;
        _dateTextField.inputView = _datePicker;
        
        UIToolbar *keyboardToolbar = [[UIToolbar alloc] init];
        [keyboardToolbar sizeToFit];
        UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonDidTap:)];
        keyboardToolbar.items = @[flexBarButton, doneBarButton];
        
        _dateTextField.inputAccessoryView = keyboardToolbar;
        [self.view addSubview:_dateTextField];
        
    }
    return self;
}

- (instancetype)initFavouriteTicketsController {
    self = [super init];
    if (self) {
        isFavourites = YES;
        sortedByAscending = NO;
        self.tickets = [NSArray new];
        self.title = @"Избранное";
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:[TicketTableViewCell class] forCellReuseIdentifier:TicketCellReuseIdentifier];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (isFavourites) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"arrow.up.arrow.down.circle"] style:UIBarButtonItemStyleDone target:self action:@selector(sortTickets)];
        self.navigationController.navigationBar.prefersLargeTitles = YES;
        
        [self createSegmentedControl];
        [self changeSource];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tickets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TicketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TicketCellReuseIdentifier forIndexPath:indexPath];
    if (isFavourites) {
        cell.favouriteTicket = [_tickets objectAtIndex:indexPath.row];
    } else {
        cell.ticket = [_tickets objectAtIndex:indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (isFavourites) return;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Действия с билетом" message:@"Что необходимо сделать с выбранным билетом?" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *favouriteAction;
    if ([[CoreDataHelper sharedInstance] isFavouriteTicket:[_tickets objectAtIndex:indexPath.row]]) {
        favouriteAction = [UIAlertAction actionWithTitle:@"Удалить из избранного" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [[CoreDataHelper sharedInstance] removeTicketFromFavourite:[self->_tickets objectAtIndex:indexPath.row]];
        }];
    } else {
        favouriteAction = [UIAlertAction actionWithTitle:@"Добавить в избранное" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[CoreDataHelper sharedInstance] addTicketToFavourite:[self->_tickets objectAtIndex:indexPath.row]];
        }];
    }
    
    UIAlertAction *notificationAction = [UIAlertAction actionWithTitle:@"Напомнить" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        self->notificationCell = [tableView cellForRowAtIndexPath:indexPath];
        [self->_dateTextField becomeFirstResponder];
    }];

    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:favouriteAction];
    [alertController addAction:notificationAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)sortTickets {
    //Сортировка по цене
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"price"
                                                 ascending:sortedByAscending];
    _tickets = [_tickets sortedArrayUsingDescriptors:@[sortDescriptor]];
    sortedByAscending = !sortedByAscending;
    
    if (sortedByAscending) {
        self.navigationItem.rightBarButtonItem.image = [UIImage systemImageNamed:@"arrow.up.arrow.down.circle.fill"];
    } else {
        self.navigationItem.rightBarButtonItem.image = [UIImage systemImageNamed:@"arrow.up.arrow.down.circle"];
    }
    
    [self.tableView reloadData];
}

- (void)createSegmentedControl {
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Поиск",@"Карта"]];
    [_segmentedControl addTarget:self action:@selector(changeSource) forControlEvents:UIControlEventValueChanged];
    _segmentedControl.tintColor = [UIColor grayColor];
    self.navigationItem.titleView = _segmentedControl;
    _segmentedControl.selectedSegmentIndex = 0;
}

- (void)changeSource {
    switch (_segmentedControl.selectedSegmentIndex) {
        case 0:
            _tickets = [[CoreDataHelper sharedInstance] favouriteTickets];
            break;
        case 1:
            _tickets = [self ticketsFromMapPrices];
            break;
        default:
            break;
    }
    [self.tableView reloadData];
}

-(NSArray *)ticketsFromMapPrices {
    NSMutableArray *tickets = [NSMutableArray new];
    NSArray *favouritePrices = [[CoreDataHelper sharedInstance] favouriteMapPrices];
    
    for (FavouriteMapPrice *price in favouritePrices) {
        Ticket *ticket = [Ticket new];
        ticket.from = price.origin;
        ticket.to = price.destination;
        ticket.departure = price.departure;
        ticket.returnDate = price.returnDate;
        ticket.price = price.value;
        [tickets addObject:ticket];
    }
    
    return tickets;
}

- (void)doneButtonDidTap:(UIBarButtonItem *)sender {
    if (_datePicker.date && notificationCell) {
        NSString *message = [NSString stringWithFormat:@"%@ - %@ за %ld руб.", notificationCell.ticket.from, notificationCell.ticket.to, (long)notificationCell.ticket.price];

        NSURL *imageURL;
//        if (notificationCell. airlineLogoView.image) {
//            NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:[NSString stringWithFormat:@"/%@.png", notificationCell.ticket.airline]];
//            if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
//                UIImage *logo = notificationCell.airlineLogoView.image;
//                NSData *pngData = UIImagePNGRepresentation(logo);
//                [pngData writeToFile:path atomically:YES];
//
//            }
//            imageURL = [NSURL fileURLWithPath:path];
//        }

        Notification notification = NotificationMake(@"Напоминание о билете", message, _datePicker.date, imageURL);
        [[NotificationCenter sharedInstance] sendNotification:notification];

        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Успешно" message:[NSString stringWithFormat:@"Уведомление будет отправлено - %@", _datePicker.date] preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    _datePicker.date = [NSDate date];
    notificationCell = nil;
    [self.view endEditing:YES];
}


@end
