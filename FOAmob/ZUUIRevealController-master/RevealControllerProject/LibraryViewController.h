//
//  BooksViewController.h
//  RevealControllerProject
//
//  Created by Lucas Rocha on 29/12/13.
//
//

#import <UIKit/UIKit.h>
#import "Library.h"
#import "AppDelegate.h"

@interface LibraryViewController : UIViewController

@property(nonatomic, retain) Library* livro;
@property(nonatomic, retain) NSMutableArray* _livros;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end
