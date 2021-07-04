//
//  TicketsViewController.m
//  AirTickets
//
//  Created by Daniil Kniss on 24.06.2021.
//

#import "TicketsViewController.h"
#import "TicketTableViewCell.h"
#import "CoreDataHelper.h"

#define TicketCellReuseIdentifier @"TicketCellIdentifier"

@interface TicketsViewController ()
@property (nonatomic, strong) NSArray *tickets;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@end

@implementation TicketsViewController {
    BOOL isFavourites;
    BOOL sortedByAscending;
}

- (instancetype)initWithTickets:(NSArray *)tickets {
    self = [super init];
    if (self)
    {
        _tickets = tickets;
        self.title = @"Билеты";
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:[TicketTableViewCell class] forCellReuseIdentifier:TicketCellReuseIdentifier];
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
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Сортировать" style:UIBarButtonItemStyleDone target:self action:@selector(sortTickets)];
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
    if ([[CoreDataHelper sharedInstance] isFavourite:[_tickets objectAtIndex:indexPath.row]]) {
        favouriteAction = [UIAlertAction actionWithTitle:@"Удалить из избранного" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [[CoreDataHelper sharedInstance] removeFromFavourite:[self->_tickets objectAtIndex:indexPath.row]];
        }];
    } else {
        favouriteAction = [UIAlertAction actionWithTitle:@"Добавить в избранное" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[CoreDataHelper sharedInstance] addToFavourite:[self->_tickets objectAtIndex:indexPath.row]];
        }];
        
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:favouriteAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)sortTickets {
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"price"
                                                 ascending:sortedByAscending];
    _tickets = [_tickets sortedArrayUsingDescriptors:@[sortDescriptor]];
    sortedByAscending = !sortedByAscending;
    
    if (sortedByAscending) {
        self.navigationItem.rightBarButtonItem.title = @"По возрастанию";
    } else {
        self.navigationItem.rightBarButtonItem.title = @"По убыванию";
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
            _tickets = [[CoreDataHelper sharedInstance] favourites];
            break;
        case 1:
            _tickets = nil;
            break;
        default:
            break;
    }
    [self.tableView reloadData];
}

@end
