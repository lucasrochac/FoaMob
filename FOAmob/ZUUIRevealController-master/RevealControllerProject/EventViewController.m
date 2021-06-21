//
//  CalendarViewController.m
//  RevealControllerProject
//
//  Created by Lucas Rocha on 29/12/13.
//
//

#import "EventViewController.h"
#import "Event.h"
#import "AppDelegate.h"

@interface EventViewController ()

@end

@implementation EventViewController

@synthesize tableView, eventArray;

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
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    [super viewDidLoad];
    
    CGRect frame;
    frame.origin.x = 3;
    frame.origin.y = 20;
    frame.size = CGSizeMake(53, 44);
    UIButton* btnVerMenu = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnVerMenu setImage:[UIImage imageNamed:@"btn_menu.png"] forState:UIControlStateNormal];
    [btnVerMenu addTarget:self.navigationController.parentViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchDown];
    btnVerMenu.frame = frame;
    [self.view addSubview:btnVerMenu];
    
    eventArray = [Event getEventData:[AppDelegate getDBPath]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [eventArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Event* evento = [[Event alloc] init];
    
    evento = [eventArray objectAtIndex:indexPath.row];
    
    NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSDate *dataNoticia = [[NSDate alloc] init];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy HH:mm"];
    dataNoticia = evento.Date;
    
    cell.detailTextLabel.text = [dateFormat stringFromDate:dataNoticia];
    cell.detailTextLabel.font = [UIFont fontWithName:@"TrebuchetMS-Italic" size:10];
    cell.detailTextLabel.textColor = [UIColor darkGrayColor];
    
    cell.textLabel.text = evento.Description;
    cell.textLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:12];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
