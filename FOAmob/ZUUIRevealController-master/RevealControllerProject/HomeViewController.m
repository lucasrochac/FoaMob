//
//  LoginViewController.m
//  RevealControllerProject
//
//  Created by Lucas Rocha on 29/12/13.
//
//

#import "HomeViewController.h"
#import "User.h"
#import "AppDelegate.h"
#import "User.h"
#import "RevealController.h"
#import "LoginViewController.h"
#import "News.h"
#import "NewsDetailViewController.h"
#import "SyncData.h"
#import "Auth.h"

@interface HomeViewController ()

@end

@implementation HomeViewController
@synthesize userName,txtNome,courseName,txtCurso,newsArray,imgBgPerfil,imgFotoPerfil,imgTopo;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
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
    
    if (![User checkLoggedUser:[AppDelegate getDBPath]])
    {
        LoginViewController* loginVC = [[LoginViewController alloc] init];
       [self presentViewController:loginVC animated:YES completion:nil];
    }
    else
    {
        [self loadHomeScreenData];
    }
    
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated
{
    [self loadHomeScreenData];
    [super viewWillAppear:animated];
}

- (void) loadHomeScreenData
{
    NSLog(@"Carregando dados da Home");
    
    login = [NSUserDefaults standardUserDefaults];
    
    usuario = [[User alloc] init];
    usuario = [User getUserDetais:[AppDelegate getDBPath] studentCode:[login stringForKey:@"login"] studentPassword:[login stringForKey:@"password"]];
        
    //carrega noticias e chama metodo que monta o scrollview
    newsArray = [News getUserNews:[AppDelegate getDBPath]];
    [self LoadScrollNews:newsArray];
    
    txtNome.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:12];
    txtCurso.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:12];
    
    txtNome.text = usuario.studentName;
    txtCurso.text = usuario.courseName;
    
    /[imgFotoPerfil setImage:[UIImage imageWithData:usuario.studentPhoto]];
}

- (void)LoadScrollNews:(NSMutableArray* )newsArrayLoaded
{
    //Conteúdo ---------
    CGRect frame;
    
    frame.size = self.scrollNews.frame.size;
    
    for (int i = 0; i < newsArrayLoaded.count; i++)
    {
        noticias = [newsArrayLoaded objectAtIndex:i];
        
        //button
        frame.origin.x = 0;
        frame.origin.y = (100 * i);
        frame.size = CGSizeMake(320, 100);
        UIButton* boxButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [boxButton setImage:[UIImage imageNamed:@"cell_news_home.png"] forState:UIControlStateNormal];
        [boxButton addTarget:self action:@selector(showNews:) forControlEvents:UIControlEventTouchDown];
        boxButton.tag = i;
        boxButton.frame = frame;
        [self.scrollNews addSubview:boxButton];
        
        //titulo // autor
        frame.origin.x = 10;
        frame.origin.y = (100 * i) + 15;
        frame.size = CGSizeMake(320, 15);
        UILabel* titulo = [[UILabel alloc] init];
        titulo.text = noticias.newsAuthor;
        titulo.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:14];
        titulo.numberOfLines = 3;
        titulo.backgroundColor = [UIColor clearColor];
        titulo.frame = frame;
        [self.scrollNews addSubview:titulo];
        
        //texto - breve, 3 linhas
        frame.origin.x = 7;
        frame.origin.y = (100 * i) + 37;
        frame.size = CGSizeMake(280, 60);
        UITextView* autor = [[UITextView alloc] init];
        NSString*strTrim = [NSMutableString stringWithString:noticias.newsText];
        if ([strTrim length] > 100)
        {
           strTrim = [strTrim substringWithRange:NSMakeRange(0, 120)];
            strTrim = [NSString stringWithFormat:@"%@...",strTrim];
        }
        autor.userInteractionEnabled = false;
        autor.scrollEnabled = false;
        autor.text = strTrim;
        autor.font = [UIFont fontWithName:@"TrebuchetMS" size:12];
        autor.backgroundColor = [UIColor clearColor];
        autor.frame = frame;
        [self.scrollNews addSubview:autor];
        
        //data
        frame.origin.x = 10;
        frame.origin.y = (100 * i) + 30;
        frame.size = CGSizeMake(320, 15);
        NSDate *dataNoticia = [[NSDate alloc] init];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd/MM/yyyy"];
        UILabel* dateLabel = [[UILabel alloc]init];
        dataNoticia = noticias.newsDate;
        dateLabel.text = [dateFormat stringFromDate:dataNoticia];
        dateLabel.font = [UIFont fontWithName:@"TrebuchetMS-Italic" size:10];
        dateLabel.textColor = [UIColor darkGrayColor];
        dateLabel.frame = frame;
        [self.scrollNews addSubview:dateLabel];
        
        self.scrollNews.contentSize = CGSizeMake(self.scrollNews.frame.size.width, 100 * [newsArrayLoaded count]);
    }
}

- (void) showNews:(UIButton*)boxButton
{
    NewsDetailViewController* details = [[NewsDetailViewController alloc] init];
    details.noticia = [newsArray objectAtIndex:boxButton.tag];
    [self  presentViewController:details animated:YES completion:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return (toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Example Code

- (IBAction)pushExample:(id)sender
{
	UIViewController *stubController = [[UIViewController alloc] init];
	stubController.view.backgroundColor = [UIColor whiteColor];
	[self.navigationController pushViewController:stubController animated:YES];
}

////////////////////////////////////////////// base 64 /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@end
