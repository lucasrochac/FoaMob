#import <UIKit/UIKit.h>
#import "ZUUIRevealController.h"
#import "HomeViewController.h"
#import "User.h"
#import "News.h"

@interface HomeViewController : UIViewController
{
    NSUserDefaults *login;
    User* usuario;
    News* noticias;
}

@property (nonatomic, retain) NSString *courseName;
@property (nonatomic, retain) NSString *userName;

@property (nonatomic, retain) NSMutableArray* newsArray;

@property (weak, nonatomic) IBOutlet UILabel *txtCurso;
@property (weak, nonatomic) IBOutlet UILabel *txtNome;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollNews;

@property (strong, nonatomic) IBOutlet UIImageView *imgFotoPerfil;
@property (strong, nonatomic) IBOutlet UIImageView *imgBgPerfil;
@property (strong, nonatomic) IBOutlet UIImageView *imgTopo;

@end
