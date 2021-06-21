//
//  Auth.m
//  RevealControllerProject
//
//  Created by Lucas Rocha on 24/04/14.
//
//

//201110460
//123mudar

#import "Auth.h"
#import "AppDelegate.h"

static sqlite3 *database = nil;
static sqlite3_stmt* addStmt = nil;
static sqlite3_stmt* deleteStmt = nil;


@implementation Auth

@synthesize idUsua, tokenUsua, matriculaUsua;

+ (void) logOff
{
    Auth* authObj = [[Auth alloc] init];
    
    NSArray* arrayTableNames = [NSArray arrayWithObjects:@"T_ALUNO",@"T_DISCIPLINA",@"T_BOLETIM",@"T_EMPRESTIMO_LIVRO", @"T_EVENTO",@"T_HORARIO_AULA", @"T_NOTICIA", nil];
    
    for (int i = 0; i < [arrayTableNames count]; i++)
    {
        NSString *tableName = [NSString stringWithFormat:@"%@",[arrayTableNames objectAtIndex:i]];
        [authObj.self cleanUserData:[AppDelegate getDBPath] tableName:tableName];
    }
}

+ (void) cleanNewsData:(NSString*)dbPath
{
    Auth* authObj = [[Auth alloc] init];
    [authObj.self cleanUserData:[AppDelegate getDBPath] tableName:@"T_NOTICIA"];
}

+ (void) cleanBooksData:(NSString*)dbPath
{
    
}

+ (void) cleanEventData:(NSString*)dbPath
{
    
}

+ (void) cleanReportData:(NSString*)dbPath
{
    
}

- (void) cleanUserData:(NSString*) dbPath tableName:(NSString* )tableName
{
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        
        NSString *sql = [NSString stringWithFormat: @"DELETE FROM %@", tableName];
                         
        const char *del_stmt = [sql UTF8String];
    
        sqlite3_prepare_v2(database, del_stmt, -1, & deleteStmt, NULL);
    
        if (sqlite3_step(deleteStmt) == SQLITE_DONE)
        {
            NSLog(@"TABELA LIMPA: %@",tableName);
        }
        else
        {
            NSLog(@"Erro ao executar query: %s", sqlite3_errmsg(database));
        }
        
        sqlite3_finalize(deleteStmt);
        sqlite3_close(database);
    }
}

+ (Auth *) Authenticate:(NSString*) matricula senha:(NSString* )senha
{
    Auth* auth = [[Auth alloc] init];
    
    NSData* jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[auth.self concatenateUrlString:@"201110460" senha:@"123mudar"]]];
    NSError* error;
    NSDictionary* resultados = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
    NSString* errorAuth = [NSString stringWithFormat:@"%@",[resultados objectForKey:@"erro"]];
    
    if ([errorAuth isEqualToString:@"1"])
    {
        auth = NULL;
    }
    else
    {
        NSMutableDictionary* dictionary = [[NSMutableDictionary alloc]init];
        dictionary = [resultados objectForKey:@"Auth"];
        auth.idUsua = [dictionary objectForKey:@"id"];
        auth.tokenUsua = [dictionary objectForKey:@"token"];
        auth.matriculaUsua = matricula;
        
        [auth.self insertAuthenticatedUserData:[AppDelegate getDBPath] auth:auth];
    }
    
    return auth;
}

- (NSString* ) concatenateUrlString:(NSString*) matricula senha:(NSString*)senha
{
    NSString* pre = [NSString stringWithFormat:@"http://tcc-teste.aws.af.cm/api/auth/?matricula="];
    NSString* paramSenha = [NSString stringWithFormat:@"&senha="];
    
    NSMutableString* fullString = [[NSMutableString alloc] init];
    
    [fullString appendString:pre];
    [fullString appendString:matricula];
    [fullString appendString:paramSenha];
    [fullString appendString:senha];
    
    return fullString;
}

- (void) insertAuthenticatedUserData:(NSString*) dbPath auth:(Auth*)auth
{
    addStmt = nil;
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        if (addStmt == nil)
        {
            NSString* queryString = [NSString stringWithFormat:@"INSERT INTO T_ALUNO (ID, CD_MATRICULA, TX_TOKEN) VALUES (?,?,?)"];
            const char *query = [queryString UTF8String];
            
            if (sqlite3_prepare_v2(database, query, -1, &addStmt, NULL) != SQLITE_OK)
            {
                NSLog(@"ERRO - INSERT T_ALUNO - SQLITE_PREPARE_V2: '%s'", sqlite3_errmsg(database));
            }
            
            else
            {
                sqlite3_bind_text(addStmt, 1, [auth.idUsua UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(addStmt, 2, [auth.matriculaUsua UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(addStmt, 3, [auth.tokenUsua UTF8String], -1, SQLITE_TRANSIENT);
                
                if (sqlite3_step(addStmt) == SQLITE_DONE)
                {
                    NSLog(@"INSERT T_ALUNO OK");
                }
                
                else
                {
                    NSLog(@"ERRO - INSERT T_ALUNO - SQLITE_DONE: '%s'", sqlite3_errmsg(database));
                }
                sqlite3_reset(addStmt);
            }
        }
        else
        {
            NSLog(@"ERRO - INSERT T_ALUNO - addStmt not nil: '%s'", sqlite3_errmsg(database));
        }
    }
    else
    {
        NSLog(@"ERRO - INSERT T_ALUNO - SQLITE3_OPEN: '%s'", sqlite3_errmsg(database));
    }
}

+ (Auth* ) getLoggedUserCredentials:(NSString*) dbPath
{
    Auth* auth = [[Auth alloc] init];
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSString* meuSelect =  [NSString stringWithFormat:@"SELECT CD_MATRICULA, ID, TX_TOKEN FROM T_ALUNO"];
        
		const char *sql = [meuSelect UTF8String];
        
		sqlite3_stmt *selectstmt;
		if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK)
        {
			while(sqlite3_step(selectstmt) == SQLITE_ROW)
            {
                auth.matriculaUsua = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 0)];
                auth.idUsua = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 1)];
                auth.tokenUsua = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 2)];
            }
        }
        else
        {
            NSLog(@"Erro executar query. '%s'", sqlite3_errmsg(database));
        }
        sqlite3_finalize(selectstmt);
    }
    sqlite3_close(database);
    
    return auth;
}

@end
