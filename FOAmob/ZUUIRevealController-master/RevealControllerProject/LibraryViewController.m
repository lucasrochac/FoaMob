//
//  BooksViewController.m
//  RevealControllerProject
//
//  Created by Lucas Rocha on 29/12/13.
//
//

#import "LibraryViewController.h"

@interface LibraryViewController ()

@end

@implementation LibraryViewController

@synthesize livro, _livros;

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

    _livros = [Library getLendedBooks:[AppDelegate getDBPath]];
    
    [self loadContent];
    
    // Do any additional setup after loading the view from its nigg.
}

- (void) loadContent
{
    //Conteúdo ---------
    CGRect frame;
    frame.size = self.scrollView.frame.size;
    
    for (int i = 0; i < _livros.count; i++)
    {
        livro = [_livros objectAtIndex:i];
        
        //box
        frame.origin.x = 0;
        frame.origin.y = (90 * i);
        frame.size = CGSizeMake(320, 90);
        UIImage* boxImg = [UIImage imageNamed:@"cell_news_home"];
        UIImageView* imgView = [[UIImageView alloc] initWithImage:boxImg];
        imgView.frame = frame;
        [self.scrollView addSubview:imgView];
        
        //nome do livro
        frame.origin.x = 10;
        frame.origin.y = (90 * i) + 20;
        frame.size = CGSizeMake(320, 30);
        UILabel* lblNomeLivro = [[UILabel alloc] init];
        lblNomeLivro.text = livro.bookName;
        lblNomeLivro.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:13];
        lblNomeLivro.numberOfLines = 2;
        lblNomeLivro.backgroundColor = [UIColor clearColor];
        lblNomeLivro.frame = frame;
        [self.scrollView addSubview:lblNomeLivro];

        frame.origin.x = 10;
        frame.origin.y = (90 * i) + 35;
        UILabel* lblDataEntregaEst = [[UILabel alloc] init];
        lblDataEntregaEst.text = [NSString stringWithFormat:@"Empréstimo: "];
        lblDataEntregaEst.font = [UIFont fontWithName:@"TrebuchetMS" size:11];
        lblDataEntregaEst.numberOfLines = 2;
        lblDataEntregaEst.backgroundColor = [UIColor clearColor];
        lblDataEntregaEst.frame = frame;
        [self.scrollView addSubview:lblDataEntregaEst];
        
        frame.origin.x = 100;
        frame.origin.y = (90 * i) + 35;
        UILabel* lblDataEntrega = [[UILabel alloc] init];
        NSDate *dataNoticia = [[NSDate alloc] init];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd/MM/yyyy"];
        dataNoticia = livro.lendDate;
        lblDataEntrega.text = [dateFormat stringFromDate:dataNoticia];
        lblDataEntrega.font = [UIFont fontWithName:@"TrebuchetMS" size:11];
        lblDataEntrega.numberOfLines = 2;
        lblDataEntrega.backgroundColor = [UIColor clearColor];
        lblDataEntrega.frame = frame;
        [self.scrollView addSubview:lblDataEntrega];
        
        frame.origin.x = 10;
        frame.origin.y = (90 * i) + 50;
        UILabel* lblDataEmprestimoEst = [[UILabel alloc] init];
        lblDataEmprestimoEst.text = [NSString stringWithFormat:@"Devolução: "];
        lblDataEmprestimoEst.font = [UIFont fontWithName:@"TrebuchetMS" size:11];
        lblDataEmprestimoEst.numberOfLines = 2;
        lblDataEmprestimoEst.backgroundColor = [UIColor clearColor];
        lblDataEmprestimoEst.frame = frame;
        [self.scrollView addSubview:lblDataEmprestimoEst];
        
        frame.origin.x = 100;
        frame.origin.y = (90 * i) + 50;
        UILabel* lblDataEmprestimo = [[UILabel alloc] init];
        [dateFormat setDateFormat:@"dd/MM/yyyy"];
        dataNoticia = livro.devolutionDate;
        lblDataEmprestimo.text = [dateFormat stringFromDate:dataNoticia];
        lblDataEmprestimo.font = [UIFont fontWithName:@"TrebuchetMS" size:11];
        lblDataEmprestimo.textColor = [UIColor redColor];
        lblDataEmprestimo.numberOfLines = 2;
        lblDataEmprestimo.backgroundColor = [UIColor clearColor];
        lblDataEmprestimo.frame = frame;
        [self.scrollView addSubview:lblDataEmprestimo];


    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
