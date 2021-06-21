//
//  ReportDetailViewController.m
//  RevealControllerProject
//
//  Created by Lucas Rocha on 17/01/14.
//
//

#import "ReportDetailViewController.h"
#import "Report.h"
#import "Subject.h"
#import "AppDelegate.h"
#import "DayEnum.h"
#import "HourEnum.h"
#import "HorarioAula.h"

@interface ReportDetailViewController ()

@end

@implementation ReportDetailViewController

@synthesize lblAVD1,lblNomeDisciplina, lblAVD2,lblAVD3,lblAVD4,lblDia,lblFaltas,lblFinal,lblHorario,lblSegCha,SubjectCode,boletim, materia,DisciplinaId;

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
    
    boletim = [Report getSujectDataById:DisciplinaId dbPath:[AppDelegate getDBPath]];
    materia = [Subject getSubjectDataById:[AppDelegate getDBPath] code:DisciplinaId];
    
    [self montarHorarios:DisciplinaId];
    
    NSLog(@"### Valor nota avd1 = %f", boletim.final);
    
    if(boletim.avd1 != 0)
    {
        lblAVD1.text = [NSString stringWithFormat:@"%.1f", boletim.avd1];
    }
    else
    {
        lblAVD1.text = [NSString stringWithFormat:@" - "];
    }
    
    if(boletim.avd2 != 0)
    {
        lblAVD2.text = [NSString stringWithFormat:@"%.1f", boletim.avd2];
    }
    else
    {
        lblAVD2.text = [NSString stringWithFormat:@" - "];
    }

    if(boletim.avd4 != 0)
    {
        lblAVD4.text = [NSString stringWithFormat:@"%.1f", boletim.avd4];
    }
    else
    {
        lblAVD4.text = [NSString stringWithFormat:@" - "];
    }

    
    if(boletim.avd3 != 0)
    {
        lblAVD3.text = [NSString stringWithFormat:@"%.1f", boletim.avd3];
    }
    else
    {
        lblAVD3.text = [NSString stringWithFormat:@" - "];
    }

    
    if (boletim.segChamada != 0)
    {
        lblSegCha.text = [NSString stringWithFormat:@"%.1f", boletim.segChamada];
    }
    else
    {
        lblSegCha.text = [NSString stringWithFormat:@" - "];
    }
    
    if (boletim.final != 0)
    {
        lblFinal.text = [NSString stringWithFormat:@"%.1f",boletim.final];
    }
    else
    {
        lblFinal.text = [NSString stringWithFormat:@" - "];
    }
        
    lblFaltas.text = [NSString stringWithFormat:@"%i", boletim.numFaltas];
    
    lblNomeDisciplina.text = materia.subjectName;
    
    // Do any additional setup after loading the view from its nib.
}

-(void) montarHorarios:(NSInteger)idDisciplina
{
    HorarioAula* objHorario = [HorarioAula getSubjectHour:[AppDelegate getDBPath] subjectId:idDisciplina];
    lblDia.text = objHorario.weekDay;
    lblHorario.text = objHorario.hour;
    
//        CGRect frame;
//        frame.origin.x = 10;
//        frame.origin.y = 430;
//        frame.size = CGSizeMake(15, 300);
//        UILabel* lblDiaSemana = [[UILabel alloc] init];
//        lblDiaSemana.text = objHorario.weekDay;
//        lblDiaSemana.frame = frame;
//        [self.view addSubview:lblDiaSemana];    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (void) loadSubjectData:(NSInteger) code
{
    NSLog(@"xonas");
}

- (IBAction)voltar:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
