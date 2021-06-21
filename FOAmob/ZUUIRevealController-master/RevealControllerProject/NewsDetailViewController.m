//
//  NewsDetailViewController.m
//  RevealControllerProject
//
//  Created by Lucas Rocha on 07/01/14.
//
//

#import "NewsDetailViewController.h"

@interface NewsDetailViewController ()

@end

@implementation NewsDetailViewController

@synthesize lblAutor,lblDate,lblTitulo,txtNoticia,noticia;

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
    
    lblAutor.text = noticia.newsAuthor;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/mm/yyyy"];
    
    lblDate.text = [dateFormatter stringFromDate:noticia.newsDate];
    txtNoticia.text = noticia.newsText;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Voltar:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
