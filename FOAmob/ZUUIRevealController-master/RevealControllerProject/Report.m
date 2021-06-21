//
//  Report.m
//  RevealControllerProject
//
//  Created by Lucas Rocha on 14/01/14.
//
//

#import "Report.h"

static sqlite3 *database = nil;
static sqlite3_stmt* addStmt = nil;

@implementation Report

@synthesize code,avd1,avd2,final,numFaltas,segChamada,avd3,avd4,media,subjectCode,segChamada2;

+ (NSMutableArray*) getReportCard: (NSString* )dbPath
{
    NSMutableArray* boletimArray = [[NSMutableArray alloc] init];
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSString* meuSelect =  [NSString stringWithFormat:@"SELECT CD_DISCIPLINA, ID_BOLETIM, NOTA_AVD1, NOTA_AVD2, NOTA_AVD3, NOTA_AVD4, NOTA_FINAL, NU_FALTAS, SEG_CHAMADA FROM T_BOLETIM"];
        
		const char *sql = [meuSelect UTF8String];
        
		sqlite3_stmt *selectstmt;
		if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK)
        {
			while(sqlite3_step(selectstmt) == SQLITE_ROW)
            {
                Report* boletim = [[Report alloc]init];
                
                boletim.subjectCode = sqlite3_column_int(selectstmt, 0);
                boletim.code = sqlite3_column_int(selectstmt, 1);
                boletim.avd1 = sqlite3_column_double(selectstmt, 2);
                boletim.avd2 = sqlite3_column_double(selectstmt, 3);
                boletim.avd3 = sqlite3_column_double(selectstmt, 4);
                boletim.avd4 = sqlite3_column_double(selectstmt, 5);
                boletim.final = sqlite3_column_double(selectstmt, 6);
                boletim.numFaltas = sqlite3_column_int(selectstmt, 7);
                boletim.segChamada = sqlite3_column_double(selectstmt, 8);
                
                [boletimArray addObject:boletim];
            }
        }
        else
        {
            NSLog(@"No data found");
        }
        sqlite3_finalize(selectstmt);
    }
    sqlite3_close(database);
    
    return boletimArray;
}

+ (Report*) getSujectDataById:(NSInteger)subjectCode dbPath:(NSString* )dbPath
{
    Report* reportObj = [[Report alloc] init];
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSString* meuSelect =  [NSString stringWithFormat:@"SELECT CD_DISCIPLINA, ID_BOLETIM, NOTA_AVD1, NOTA_AVD2, NOTA_AVD3, NOTA_AVD4, NOTA_FINAL, NU_FALTAS, NOTA_SEG_CHAMADA FROM T_BOLETIM WHERE CD_DISCIPLINA = %i", subjectCode];
        
		const char *sql = [meuSelect UTF8String];
        
		sqlite3_stmt *selectstmt;
		if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK)
        {
			while(sqlite3_step(selectstmt) == SQLITE_ROW)
            {
                reportObj = [[Report alloc]init];
                
                reportObj.subjectCode = sqlite3_column_int(selectstmt, 0);
                reportObj.code = sqlite3_column_int(selectstmt, 1);
                reportObj.avd1 = sqlite3_column_double(selectstmt, 2);
                reportObj.avd2 = sqlite3_column_double(selectstmt, 3);
                reportObj.avd3 = sqlite3_column_double(selectstmt, 4);
                reportObj.avd4 = sqlite3_column_double(selectstmt, 5);
                reportObj.final = sqlite3_column_double(selectstmt, 6);
                reportObj.numFaltas = sqlite3_column_int(selectstmt, 7);
                reportObj.segChamada = sqlite3_column_double(selectstmt, 8);
            }
        }
        else
        {
            NSLog(@"No data found");
        }
        sqlite3_finalize(selectstmt);
    }
    sqlite3_close(database);
    
    return reportObj;
}

+ (void) insertReportData: (NSString*) dbPath report: (Report* ) report
{
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        if (addStmt == nil)
        {
            NSString* queryString = [NSString stringWithFormat:@"INSERT INTO T_BOLETIM (ID_BOLETIM, CD_DISCIPLINA, NOTA_AVD1, NOTA_AVD2, NOTA_AVD3, NOTA_AVD4, NOTA_SEG_CHAMADA, NOTA_FINAL, NU_FALTAS, NOTA_SEG_CHAMADA_2) VALUES (?,?,?,?,?,?,?,?,?,?)"];
            const char *query = [queryString UTF8String];
            
            if (sqlite3_prepare_v2(database, query, -1, &addStmt, NULL) != SQLITE_OK)
            {
                NSAssert1(0, @"Erro executar query. '%s'", sqlite3_errmsg(database));
            }
            
            else
            {
                sqlite3_bind_int(addStmt, 1,report.code);
                sqlite3_bind_int(addStmt, 2,report.subjectCode);
                sqlite3_bind_double(addStmt, 3, report.avd1);
                sqlite3_bind_double(addStmt, 4, report.avd2);
                sqlite3_bind_double(addStmt, 5, report.avd3);
                sqlite3_bind_double(addStmt, 6, report.avd4);
                sqlite3_bind_double(addStmt, 7, report.segChamada);
                sqlite3_bind_double(addStmt, 8, report.segChamada2);
                sqlite3_bind_double(addStmt, 9, report.final);
                sqlite3_bind_int(addStmt, 10, report.numFaltas);
                
                if (sqlite3_step(addStmt) == SQLITE_DONE)
                {
                    NSLog(@"OK");
                }
                
                else
                {
                    NSLog(@"1#ERROR . '%s'", sqlite3_errmsg(database));
                }
                sqlite3_reset(addStmt);
            }
        }
        else
        {
            NSLog(@"not nil . '%s'", sqlite3_errmsg(database));
        }
    }
    else
    {
        NSLog(@"2#ERROR . '%s'", sqlite3_errmsg(database));
    }
    addStmt = nil;

}

@end
