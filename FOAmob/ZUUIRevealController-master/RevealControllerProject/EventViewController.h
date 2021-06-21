//
//  CalendarViewController.h
//  RevealControllerProject
//
//  Created by Lucas Rocha on 29/12/13.
//
//

#import <UIKit/UIKit.h>

@interface EventViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, retain) NSMutableArray* eventArray;

@end
