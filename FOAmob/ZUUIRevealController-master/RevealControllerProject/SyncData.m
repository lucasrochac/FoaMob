//
//  SyncData.m
//  RevealControllerProject
//
//  Created by Lucas Rocha on 29/12/13.
//
//

#import "SyncData.h"
#import "Library.h"
#import "AppDelegate.h"
#import "News.h"
#import "Util.h"
#import "Event.h"
#import "Report.h"
#import "Subject.h"
#import "User.h"

@implementation SyncData

@synthesize dict, array;

+ (void) startSync:(NSString *)matricula lastSyncDate:(NSDate *)lastSyncDate token:(NSString *)token idUsua:(NSInteger)idUsua
{
    SyncData* sync = [[SyncData alloc] init];
    
    @try
    {
        [sync.self syncUserData:matricula token:token idUsua:idUsua];
        [sync.self syncBooks:matricula lastSyncDate:lastSyncDate token:token];
        [sync.self syncNews:matricula lastSyncDate:lastSyncDate token:token];
        [sync.self syncEvents:matricula lastSyncDate:lastSyncDate token:token];
        [sync.self syncSubject:matricula lastSyncDate:lastSyncDate token:token];
        [sync.self syncReport:matricula lastSyncDate:lastSyncDate token:token];
    }
    
    @catch (NSException *exception)
    {
        UIAlertView* errorAlert = [[UIAlertView alloc] initWithTitle:@"ERRO" message:@"#01 - Ocorreu um erro na sincronização com o nosso servidor. Verifique sua conexão com a internet" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [errorAlert show];
    }
}

- (void) syncUserData:(NSString* )matricula token:(NSString* )token idUsua:(NSInteger)idUsua
{
    User* usuario = [[User alloc] init];
    
    NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] init];
    
    dictionary = [self getArrayFromJsonDict:@"http://tcc-teste.aws.af.cm/api/alunos/?aluno=1&token=123mudar" jsonKey:@"Aluno"];

    usuario.studentCode = matricula;
    usuario.studentId = idUsua;
    usuario.studentName = [dictionary objectForKey:@"nome"];
    usuario.courseName = [dictionary objectForKey:@"curso"];
    usuario.periodCode = [[dictionary objectForKey:@"curso_periodo_nu"] integerValue];
    usuario.periodName = [dictionary objectForKey:@"curso_periodo_nome"];

    [User updateUserData:[AppDelegate getDBPath] usuario:usuario userCode:matricula userId:idUsua];
}

- (void) syncBooks: (NSString *) matricula lastSyncDate:(NSDate*)lastSyncDate token:(NSString*)token
{
    NSMutableArray* arrayObject = [[NSMutableArray alloc] init];
    
    array = [self getArrayFromJson:@"http://tcc-teste.aws.af.cm/api/emprestimosLivros/?aluno=1&token=123mudar" jsonKey:@"EmprestimosLivro"];
    
    for (int i = 0; i < [array count]; i++)
    {
        dict = [array objectAtIndex:i];
        
        Library* livro = [[Library alloc] init];
        livro.bookName = [dict objectForKey:@"livro_nome"];
        livro.devolutionDate = [dict objectForKey:@"dt_entrega"];
        livro.lendDate = [dict objectForKey:@"dt_emprestimo"];
        
        [arrayObject addObject:livro];
    }
    
    [Library insertLendedBooks:[AppDelegate getDBPath] livros:arrayObject];
}

- (void) syncNews: (NSString *) matricula lastSyncDate:(NSDate*)lastSyncDate token:(NSString*)token;
{
    NSMutableArray* arrayObject = [[NSMutableArray alloc] init];
    
    array = [self getArrayFromJson:@"http://tcc-teste.aws.af.cm/api/noticias/?aluno=1&token=123mudar" jsonKey:@"Noticia"];
    
    for (int i = 0; i < [array count]; i++)
    {
        dict = [array objectAtIndex:i];
        
        News* noticia = [[News alloc] init];
        
        NSString*stringDate = [NSString stringWithFormat:@"%@", [dict objectForKey:@"created"]];
        stringDate = [stringDate substringWithRange:NSMakeRange(0, 10)];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-mm-dd"];
        noticia.newsDate = [dateFormatter dateFromString:stringDate];
        
        noticia.newsAuthor = [dict objectForKey:@"autor"];
        noticia.newsText = [dict objectForKey:@"texto"];
        
        [arrayObject addObject:noticia];
    }
    [News insertUserNews:[AppDelegate getDBPath] noticias:arrayObject];
}

- (void) syncEvents: (NSString *) matricula lastSyncDate:(NSDate*)lastSyncDate token:(NSString*)token
{
    NSMutableArray* arrayObject = [[NSMutableArray alloc] init];
    
    array = [self getArrayFromJson:@"http://tcc-teste.aws.af.cm/api/eventos/?aluno=1&token=123mudar" jsonKey:@"Evento"];
    
    for (int i = 0 ; i < [array count]; i ++)
    {
        dict = [array objectAtIndex:i];
        
        Event* evento = [[Event alloc] init];
        evento.Date = [dict objectForKey:@"dt_evento"];
        evento.description = [dict objectForKey:@"nome"];
        
        [arrayObject addObject:evento];
    }
    [Event insertEvent:[AppDelegate getDBPath] Event:arrayObject];
}

- (void) syncSubject: (NSString *) matricula lastSyncDate:(NSDate*)lastSyncDate token:(NSString*)token
{
    NSMutableArray* arrayObject = [[NSMutableArray alloc] init];

    array = [self getArrayFromJson:@"http://tcc-teste.aws.af.cm/api/disciplinas/?aluno=1&token=123mudar" jsonKey:@"Disciplina"];
    
    for (int i = 0 ; i < [array count]; i ++)
    {
        dict = [array objectAtIndex:i];

        Subject* disciplina = [[Subject alloc] init];
        disciplina.code = [[dict objectForKey:@"id"] integerValue];
        disciplina.subjectName = [dict objectForKey:@"disciplina"];
        disciplina.subjectTeacher = [dict objectForKey:@"professor"];
        disciplina.avd1Date = [dict objectForKey:@"dt_avd1"];
        disciplina.avd2Date = [dict objectForKey:@"dt_avd2"];
        disciplina.avd3Date = [dict objectForKey:@"dt_avd3"];
        disciplina.avd4Date = [dict objectForKey:@"dt_avd4"];
        disciplina.finalDate = [dict objectForKey:@"dt_final"];
        disciplina.segChamDate2 = [dict objectForKey:@"dt_seg_chamada_2"];
        
        [arrayObject addObject:disciplina];
    }
    [Subject insertSubjectData:[AppDelegate getDBPath] subjectArray:arrayObject];
}

- (void) syncReport: (NSString *) matricula lastSyncDate:(NSDate*)lastSyncDate token:(NSString*)token
{
    NSMutableArray* arrayIds = [Subject getSubjectIds:[AppDelegate getDBPath]];

    for (int i = 0 ; i < [arrayIds count]; i ++)
    {
        int idReport = [[arrayIds objectAtIndex:i] integerValue];
        
        NSString* urlJson = [NSString stringWithFormat:@"http://tcc-teste.aws.af.cm/api/boletins/?aluno=1&token=123mudar&disciplina=%i", idReport];
        
        NSLog(@"URL JSON - %@", urlJson);
        
        dict = [self getArrayFromJsonDict:urlJson jsonKey:@"Boletim"];
        
        Report *boletim = [[Report alloc] init];
        boletim.subjectCode = [[arrayIds objectAtIndex:i]integerValue];
        boletim.numFaltas = [[dict objectForKey:@"faltas"]integerValue];
        boletim.avd1 = [self verifyNull:[dict objectForKey:@"nota_avd1"]];
        boletim.avd2 = [self verifyNull:[dict objectForKey:@"nota_avd2"]];
        boletim.avd3 = [self verifyNull:[dict objectForKey:@"nota_avd3"]];
        boletim.avd4 = [self verifyNull:[dict objectForKey:@"nota_avd4"]];
        boletim.final = [self verifyNull:[dict objectForKey:@"nota_final"]];
        boletim.segChamada = [self verifyNull:[dict objectForKey:@"nota_2_ch"]];
        boletim.segChamada2 = [self verifyNull:[dict objectForKey:@"nota_2_ch_2"]];
        [Report insertReportData:[AppDelegate getDBPath] report:boletim];
    }

}

+ (void) syncOnlyNews: (NSString *) matricula lastSyncDate:(NSDate*)date token:(NSString*)token
{
    SyncData* sync = [[SyncData alloc] init];
    [sync.self syncNews:matricula lastSyncDate:date token:token];
}

+ (void) syncOnlyEvents: (NSString *) matricula lastSyncDate:(NSDate*)date token:(NSString*)token
{
    SyncData* sync = [[SyncData alloc] init];
    [sync.self syncEvents:matricula lastSyncDate:date token:token];
}

+ (void) syncOnlyReport: (NSString *) matricula lastSyncDate:(NSDate*)date token:(NSString*)token
{
    SyncData* sync = [[SyncData alloc] init];
    [sync.self syncSubject:matricula lastSyncDate:date token:token];
    [sync.self syncReport:matricula lastSyncDate:date token:token];
}

+ (void) syncOnlyBooks: (NSString *) matricula lastSyncDate:(NSDate*)date token:(NSString*)token
{
    SyncData* sync = [[SyncData alloc] init];
    [sync.self syncBooks:matricula lastSyncDate:date token:token];
}

- (NSMutableArray* ) getArrayFromJson: (NSString* )url jsonKey: (NSString* )jsonKey
{
    NSData* jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    NSError* error;
    NSDictionary* resultados = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    return [resultados objectForKey:jsonKey];
}

- (NSMutableDictionary* ) getArrayFromJsonDict: (NSString* )url jsonKey: (NSString* )jsonKey
{
    NSData* jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    NSError* error;
    NSMutableDictionary* resultados = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    return [resultados objectForKey:jsonKey];
}

-(float) verifyNull:(NSString* )valor
{
    if(valor == (NSString* )[NSNull null])
    {
        return 0.0;
    }
    else
    {
        return [valor floatValue];
    }
}

//- (NSString* ) setupURL:(NSString*)prefix idUsua:(NSString* )idUsua token:(NSString*)token hasDate:(BOOL)hasDate
//{
//    //http://tcc-teste.aws.af.cm/api/disciplinas/?aluno=1&token=123mudar
//    NSString* strAluno = [NSString stringWithFormat:@"aluno="];
//    NSString* strToken = [NSString stringWithFormat:@"?token="];
//    
//    return @"";
//}

@end
