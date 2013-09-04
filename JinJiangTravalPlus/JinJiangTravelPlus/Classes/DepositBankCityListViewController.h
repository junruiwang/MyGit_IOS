
#import <UIKit/UIKit.h>
#import "HTTPConnection.h"
#import "LoadingIndicatorViewController.h"
#import "AllCity.h"
#import "BankCityListParser.h"

@protocol DepositBankCityListViewControllerDelegate <NSObject>

@optional

- (void) buildCity: (AllCity *) city;

@end

@interface DepositBankCityListViewController : UIViewController <UISearchBarDelegate, GDataXMLParserDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property(nonatomic, assign) id<DepositBankCityListViewControllerDelegate> delegate;

@property (strong, nonatomic) NSMutableArray *keys;

@property (strong, nonatomic) NSMutableDictionary *citys;

@property (strong, nonatomic) IBOutlet UISearchBar *search;

@property (nonatomic, retain) NSString *selectedCityName;

@property (nonatomic, retain) HTTPConnection *connection;

@property (nonatomic,strong) BankCityListParser *bankCityListParser;

@property (nonatomic,strong) NSIndexPath *lastIndextPath;

@end
