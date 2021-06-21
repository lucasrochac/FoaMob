//
//  ReportViewController.h
//  RevealControllerProject
//
//  Created by Lucas Rocha on 29/12/13.
//
//

#import <UIKit/UIKit.h>
#import "Subject.h"

@interface ReportViewController : UIViewController
{
    Subject* subjectObj;
}
@property (nonatomic, retain) NSMutableArray* materias;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end
