//
//  NewsViewController.h
//  RevealControllerProject
//
//  Created by Lucas Rocha on 09/01/14.
//
//

#import <UIKit/UIKit.h>

@interface NewsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray* newsArray;

- (IBAction)update:(id)sender;

@end
