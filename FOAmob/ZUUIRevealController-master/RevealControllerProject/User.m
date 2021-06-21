//
//  User.m
//  RevealControllerProject
//
//  Created by Lucas Rocha on 31/12/13.
//
//

#import "User.h"

@implementation User

static sqlite3 *database = nil;
static sqlite3_stmt *updtStmt = nil;
static sqlite3_stmt *selectStmt =nil;


@synthesize isDetailViewHydrated, isDirty, studentCode, studentPhoto, studentName, studentToken,courseId,courseName,periodCode,periodName;

+ (User* )getUserDetais:(NSString* )dbPath studentCode:(NSString*)StudentCode studentPassword:(NSString *)studentPassword;
{
    User* userObj;
    
	if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSString* selectStatement =  [NSString stringWithFormat:@"SELECT CD_MATRICULA, NM_USUARIO, TX_FOTO, TX_TOKEN, CURSO_ID, NOME_CURSO, PERIODO_NOME FROM T_ALUNO"];
        
		if(sqlite3_prepare_v2(database, [selectStatement UTF8String], -1, &selectStmt, NULL) == SQLITE_OK)
        {
			while(sqlite3_step(selectStmt) == SQLITE_ROW)
            {
                userObj = [[User alloc] init];
                
                userObj.studentCode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStmt, 0)];
                userObj.studentName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStmt, 1)];
                int len = 0;
                len = sqlite3_column_bytes(selectStmt, 2);
                userObj.studentPhoto = [NSData dataWithBytes:sqlite3_column_blob(selectStmt, 2) length: len];
                userObj.studentToken = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStmt, 3)];
                userObj.courseId = sqlite3_column_int(selectStmt, 4);
                userObj.courseName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStmt, 5)];
                userObj.periodCode = sqlite3_column_int(selectStmt, 6);
                
            }
            sqlite3_finalize(selectStmt);
        }
        else
        {
            NSLog(@"ERROR . '%s'", sqlite3_errmsg(database));
        }
        sqlite3_close(database);
    }
    return userObj;
}

+ (void) updateUserData:(NSString*) dbPath usuario:(User *)usuario userCode:(NSString* )userCode userId:(NSInteger)userId
{
    updtStmt = nil;
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        if (updtStmt == nil)
        {
            NSString* queryString = [NSString stringWithFormat:@"UPDATE T_ALUNO SET NM_USUARIO = ?, CURSO_ID = ?, NOME_CURSO = ?, TX_FOTO = ?, PERIODO_NOME = ?, NU_PERIODO = ? WHERE ID = %i", userId];
            const char *query = [queryString UTF8String];
            
            if (sqlite3_prepare_v2(database, query, -1, &updtStmt, NULL) == SQLITE_OK)
            {
                sqlite3_bind_text(updtStmt, 1, [usuario.studentName UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_int(updtStmt, usuario.courseId, 2);
                sqlite3_bind_text(updtStmt, 3, [usuario.courseName UTF8String], -1, SQLITE_TRANSIENT);
                
                NSData* data = [usuario.self getUserDefautPhoto:userCode];
                
                //sqlite3_bind_text(updtStmt, 4, [[usuario.self getUserDefautPhoto:usuario.studentCode]UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_blob(updtStmt, 4, [data bytes], [data length], SQLITE_TRANSIENT);
                sqlite3_bind_text(updtStmt, 5, [usuario.periodName UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_int(updtStmt, usuario.periodCode, 6);
                
                if (sqlite3_step(updtStmt) == SQLITE_DONE)
                {
                    NSLog(@"OK");
                }
                else
                {
                    NSLog(@"ERRO AO EXECUTAR QUERY %s", sqlite3_errmsg(database));
                }
                sqlite3_reset(updtStmt);
            }
            
            else
            {
                NSLog(@"ERRO AO EXECUTAR QUERY %s", sqlite3_errmsg(database));
            }
        }
    }
    else
    {
        NSAssert1(0, @"ERROR . '%s'", sqlite3_errmsg(database));
    }
}

+ (BOOL) checkLoggedUser:(NSString*)dbPath
{
    int countResult = 0;
    
	if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSString* selectStatement =  [NSString stringWithFormat:@"SELECT COUNT(*) FROM T_ALUNO"];
        
		sqlite3_stmt *selectStmt;
        
		if(sqlite3_prepare_v2(database, [selectStatement UTF8String], -1, &selectStmt, NULL) == SQLITE_OK)
        {
			while(sqlite3_step(selectStmt) == SQLITE_ROW)
            {
                countResult = sqlite3_column_int(selectStmt, 0);
            }
            sqlite3_finalize(selectStmt);
        }
        else
        {
            NSAssert1(0, @"ERROR . '%s'", sqlite3_errmsg(database));
        }
        sqlite3_close(database);
    }
    
    if (countResult == 1)
    {
        return  true;
    }
    else
    {
        return false;
    }
}

-(NSData* ) getUserDefautPhoto:(NSString* )matricula
{
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://web.unifoa.edu.br/portal/FotosDRA/%@.jpg",matricula]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"http://web.unifoa.edu.br/portal/banner_inicial/inicial_blank.asp" forHTTPHeaderField:@"Referer"];
    
    NSError *error;
    NSURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

    return data;
}

@end
