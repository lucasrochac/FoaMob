/* 
 
 Copyright (c) 2011, Philip Kluz (Philip.Kluz@zuui.org)
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 
 * Neither the name of Philip Kluz, 'zuui.org' nor the names of its contributors may 
 be used to endorse or promote products derived from this software 
 without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL PHILIP KLUZ BE LIABLE FOR ANY DIRECT, 
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 */

/*
 * The following lines are crucial to understanding how the ZUUIRevealController works.
 *
 * In this example, the FrontViewController is contained inside of a UINavigationController.
 * And the UINavigationController is contained inside of a ZUUIRevealController. Thus the
 * following hierarchy is created:
 *
 * - ZUUIRevealController is parent of:
 * - - UINavigationController is parent of:
 * - - - FrontViewController
 *
 * If you don't want the UINavigationController in between (which is totally fine) all you need to
 * do is to adjust the if-condition below in a way to suit your needs. If the hierarchy were to look
 * like this:
 *
 * - ZUUIRevealController is parent of:
 * - - FrontViewController
 *
 * Without a UINavigationController in between, you'd need to change:
 * self.navigationController.parentViewController TO: self.parentViewController
 *
 * Note that self.navigationController is equal to self.parentViewController. Thus you could generalize
 * the code even more by calling self.parentViewController.parentViewController. In order to make
 * the code easier to understand I decided to go with self.navigationController.
 *
 */

#import "LoginViewController.h"
#import "User.h"
#import "AppDelegate.h"
#import "HomeViewController.h"
#import "Event.h"
#import "Auth.h"
#import "SyncData.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize txtLogin, txtPassword;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL) textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Login:(id)sender
{
    [self autoLogin];
}

- (void) autoLogin
{
    if ([txtLogin.text isEqualToString:@""] || [txtPassword.text isEqualToString:@""])
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Erro" message:@"Por favor, preencha os campos de matricula e senha corretamente!" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        Auth* auth = [Auth Authenticate:txtLogin.text senha:txtPassword.text];
        @try
        {
            [SyncData startSync:auth.matriculaUsua lastSyncDate:NULL token:auth.tokenUsua idUsua:[auth.idUsua integerValue]];

            [self dismissViewControllerAnimated:YES completion:nil];
//            HomeViewController* homeVc = [[HomeViewController alloc] init];
//            [self presentViewController:homeVc animated:YES completion:Nil];
            
        }
        @catch (NSException *exception)
        {
//            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Erro" message:@"Por favor, preencha os campos de matricula e senha corretamente!" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//            [alert show];
        }
        
    }
}

@end