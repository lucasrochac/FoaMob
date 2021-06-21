
//
//  LoginViewController.h
//  RevealControllerProject
//
//  Created by Lucas Rocha on 29/12/13.
//
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"

@interface LoginViewController : UIViewController
{
    NSUserDefaults *login;
}
@property (weak, nonatomic) IBOutlet UITextField *txtLogin;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

- (IBAction)Login:(id)sender;
@end
