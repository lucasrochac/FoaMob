//
//  ReportViewController.m
//  RevealControllerProject
//
//  Created by Lucas Rocha on 29/12/13.
//
//

#import "ReportViewController.h"
#import "ReportDetailViewController.h"
#import "Report.h"
#import "Subject.h"
#import "AppDelegate.h"
#import "DayEnum.h"
#import "HourEnum.h"

@interface ReportViewController ()

@end

@implementation ReportViewController

@synthesize materias,scrollView;

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
    
    materias = [Subject getBasicDataToReport:[AppDelegate getDBPath]];
    [self loadScrollViewData];
    
}

- (void) loadScrollViewData
{
    for(int i = 0; i < materias.count; i++)
    {
        subjectObj = [materias objectAtIndex:i];
        
        CGRect frame;
        
        //button
        frame.origin.x = 0;
        frame.origin.y = (50 * i);
        frame.size = CGSizeMake(320, 50);
        UIButton* boxButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [boxButton setImage:[UIImage imageNamed:@"cell_news_home.png"] forState:UIControlStateNormal];
        [boxButton addTarget:self action:@selector(showSubjectDetais:) forControlEvents:UIControlEventTouchDown];
        boxButton.tag = i;
        boxButton.frame = frame;
        [self.scrollView addSubview:boxButton];
        
        //nome da materia
        frame.origin.x = 10;
        frame.origin.y = (50 * i) + 5;
        frame.size = CGSizeMake(300, 30);
        UILabel* lblNomeDisciplina = [[UILabel alloc] init];
        lblNomeDisciplina.text = subjectObj.subjectName;
        lblNomeDisciplina.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:16];
        lblNomeDisciplina.numberOfLines = 3;
        lblNomeDisciplina.backgroundColor = [UIColor clearColor];
        lblNomeDisciplina.frame = frame;
        [self.scrollView addSubview:lblNomeDisciplina];
        
        //nome do professor
        frame.origin.x = 10;
        frame.origin.y = (50 * i) + 20;
        frame.size = CGSizeMake(300, 30);
        UILabel* lblNomeProfessor = [[UILabel alloc] init];
        lblNomeProfessor.text = subjectObj.subjectTeacher;
        lblNomeProfessor.font = [UIFont fontWithName:@"TrebuchetMS" size:12];
        lblNomeProfessor.numberOfLines = 3;
        lblNomeProfessor.backgroundColor = [UIColor clearColor];
        lblNomeProfessor.frame = frame;
        [self.scrollView addSubview:lblNomeProfessor];
        
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, 90 * [materias count]);
    }
}

- (void) showSubjectDetais: (UIButton*)button
{
    ReportDetailViewController* reportDetail = [[ReportDetailViewController alloc] init];
    subjectObj = [materias objectAtIndex:button.tag];
    
    NSLog(@"codigo subj = %i", subjectObj.code);
    
    reportDetail.DisciplinaId = subjectObj.code;

    [self presentViewController:reportDetail animated:YES completion:nil];//^(void) {}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
