//
//  NewsViewController.m
//  RevealControllerProject
//
//  Created by Lucas Rocha on 09/01/14.
//
//  rosenclever@ig.com.br

#import "NewsViewController.h"
#import "News.h"
#import "AppDelegate.h"
#import "NewsDetailViewController.h"
#import "SyncData.h"
#import "Auth.h"

@interface NewsViewController ()

@end

@implementation NewsViewController

@synthesize newsArray,tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    
    CGRect frame;
    frame.origin.x = 3;
    frame.origin.y = 20;
    frame.size = CGSizeMake(53, 44);
    UIButton* btnVerMenu = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnVerMenu setImage:[UIImage imageNamed:@"btn_menu.png"] forState:UIControlStateNormal];
    [btnVerMenu addTarget:self.navigationController.parentViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchDown];
    btnVerMenu.frame = frame;
    [self.view addSubview:btnVerMenu];
    
    [self loadData];
}

-(void)loadData
{
    newsArray = [News getUserNews:[AppDelegate getDBPath]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [newsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    News* noticia = [[News alloc] init];
    noticia = [newsArray objectAtIndex:indexPath.row];
    
    NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSDate *dataNoticia = [[NSDate alloc] init];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    dataNoticia = noticia.newsDate;
    
    cell.detailTextLabel.text = [dateFormat stringFromDate:dataNoticia];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    cell.detailTextLabel.font = [UIFont fontWithName:@"TrebuchetMS-Italic" size:11];
    
    cell.textLabel.text = noticia.newsText;
    cell.textLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:13];
    cell.textLabel.numberOfLines = 2;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsDetailViewController* detailVC = [[NewsDetailViewController alloc] init];
    detailVC.noticia = [newsArray objectAtIndex:indexPath.row];
    [self presentViewController:detailVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)update:(id)sender
{
    Auth* credentials = [[Auth alloc] init];
    [Auth cleanNewsData:[AppDelegate getDBPath]];
    [Auth getLoggedUserCredentials:[AppDelegate getDBPath]];
    [SyncData syncOnlyNews:credentials.idUsua lastSyncDate:[NSDate date] token:credentials.tokenUsua];
    [self loadData];
    [tableView reloadData];
}

@end
