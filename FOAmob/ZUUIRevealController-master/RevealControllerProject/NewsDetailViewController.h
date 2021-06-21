//
//  NewsDetailViewController.h
//  RevealControllerProject
//
//  Created by Lucas Rocha on 07/01/14.
//
//

#import <UIKit/UIKit.h>
#import "News.h"

@interface NewsDetailViewController : UIViewController

@property (nonatomic, retain) News* noticia;

@property (strong, nonatomic) IBOutlet UILabel *lblTitulo;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UILabel *lblAutor;
@property (strong, nonatomic) IBOutlet UITextView *txtNoticia;

- (IBAction)Voltar:(id)sender;

@end
