//
//  ReportDetailViewController.h
//  RevealControllerProject
//
//  Created by Lucas Rocha on 17/01/14.
//
//

#import <UIKit/UIKit.h>
#import "Report.h"
#import "Subject.h"

@interface ReportDetailViewController : UIViewController
{
    NSInteger DisciplinaId;
}

@property (nonatomic, readwrite) NSInteger DisciplinaId;

@property (nonatomic, readwrite) Report* boletim;
@property (nonatomic, retain) Subject* materia;

@property (strong, nonatomic) IBOutlet UILabel *lblAVD1;
@property (strong, nonatomic) IBOutlet UILabel *lblAVD2;
@property (strong, nonatomic) IBOutlet UILabel *lblSegCha;
@property (strong, nonatomic) IBOutlet UILabel *lblFinal;
@property (strong, nonatomic) IBOutlet UILabel *lblAVD3;
@property (strong, nonatomic) IBOutlet UILabel *lblAVD4;

@property (strong, nonatomic) IBOutlet UILabel *lblDia;
@property (strong, nonatomic) IBOutlet UILabel *lblHorario;

@property (strong, nonatomic) IBOutlet UILabel *lblFaltas;

@property (nonatomic,readwrite) NSInteger SubjectCode;
@property (strong, nonatomic) IBOutlet UILabel *lblNomeDisciplina;

+ (void) loadSubjectData:(NSInteger) code;
- (IBAction)voltar:(id)sender;
@end
