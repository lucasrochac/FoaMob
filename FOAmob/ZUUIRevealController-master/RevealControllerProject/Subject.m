//
//  Subject.m
//  RevealControllerProject
//
//  Created by Lucas Rocha on 16/01/14.
//
//

#import "Subject.h"

static sqlite3* database = nil;
static sqlite3_stmt* addStmt = nil;

@implementation Subject

@synthesize code,avd1Date,avd2Date,finalDate,segChamDate,subjectName,subjectTeacher,avd3Date,avd4Date,segChamDate2;

+ (NSMutableArray*) getBasicDataToReport: (NSString*)dbPath
{
    NSMutableArray* subjectBasicDataArray = [[NSMutableArray alloc] init];
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSString* meuSelect =  [NSString stringWithFormat:@"SELECT ID_DISCIPLINA, NM_DISCIPLINA, NM_PROFESSOR FROM T_DISCIPLINA"];
        
		const char *sql = [meuSelect UTF8String];
        
		sqlite3_stmt *selectstmt;
		if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK)
        {
			while(sqlite3_step(selectstmt) == SQLITE_ROW)
            {
                Subject* subjectObj = [[Subject alloc] init];
                
                subjectObj.code = sqlite3_column_int(selectstmt, 0);
                subjectObj.subjectName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 1)];
                subjectObj.subjectTeacher = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 2)];

                [subjectBasicDataArray addObject:subjectObj];
            }

        }
        else
        {
            NSLog(@"Erro executar query. '%s'", sqlite3_errmsg(database));
        }
        sqlite3_finalize(selectstmt);
    }
    sqlite3_close(database);
    return subjectBasicDataArray;
}

+ (Subject*) getSubjectDataById: (NSString*)dbPath code:(int)subjectCode
{
    Subject* subjectObj = [[Subject alloc] init];
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSString* meuSelect =  [NSString stringWithFormat:@"SELECT ID_DISCIPLINA, NM_DISCIPLINA, NM_PROFESSOR, DT_AVD1, DT_AVD2,DT_AVD3,DT_AVD4, DT_FINAL, DT_SEG_CHAMADA FROM T_DISCIPLINA WHERE ID_DISCIPLINA = %i", subjectCode];
        
		const char *sql = [meuSelect UTF8String];
        
		sqlite3_stmt *selectstmt;
		if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK)
        {
			while(sqlite3_step(selectstmt) == SQLITE_ROW)
            {
                subjectObj = [[Subject alloc] init];
                
                subjectObj.code = sqlite3_column_int(selectstmt, 0);
                subjectObj.subjectName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 1)];
                subjectObj.subjectTeacher = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 2)];

                NSString* dateString = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 3)];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"dd-MM-yyyy"];
                subjectObj.avd1Date = [dateFormatter dateFromString:dateString];

                dateString = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 4)];
                dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"dd-MM-yyyy"];
                subjectObj.avd2Date = [dateFormatter dateFromString:dateString];
                
                dateString = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 5)];
                dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"dd-MM-yyyy"];
                subjectObj.avd3Date = [dateFormatter dateFromString:dateString];
                
                dateString = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 6)];
                dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"dd-MM-yyyy"];
                subjectObj.avd4Date = [dateFormatter dateFromString:dateString];
                
                dateString = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 7)];
                dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"dd-MM-yyyy"];
                subjectObj.finalDate = [dateFormatter dateFromString:dateString];
                
                dateString = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 8)];
                dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"dd-MM-yyyy"];
                subjectObj.segChamDate = [dateFormatter dateFromString:dateString];
                
            }
        }
        else
        {
            NSLog(@"No data found");
        }
        sqlite3_finalize(selectstmt);
    }
    sqlite3_close(database);
    
    return subjectObj;
}

+ (NSMutableArray*)getSubjectIds:(NSString*) dbPath
{
    NSMutableArray* arrayIds = [[NSMutableArray alloc] init];
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSString* meuSelect =  [NSString stringWithFormat:@"SELECT ID_DISCIPLINA FROM T_DISCIPLINA"];
        
		const char *sql = [meuSelect UTF8String];
        
		sqlite3_stmt *selectstmt;
		if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK)
        {
			while(sqlite3_step(selectstmt) == SQLITE_ROW)
            {
                NSLog(@"id disciplina = %@",[NSNumber numberWithInt:sqlite3_column_int(selectstmt, 0)]);
                [arrayIds addObject:[NSNumber numberWithInt:sqlite3_column_int(selectstmt, 0)]];
            }
        }
        else
        {
            NSLog(@"No data found");
        }
        sqlite3_finalize(selectstmt);
    }
    sqlite3_close(database);
    return arrayIds;
}

+ (void) insertSubjectData:(NSString *) dbPath subjectArray:(NSMutableArray*) subjectArray
{
    Subject* disciplina = [[Subject alloc] init];
    
    for (int i = 0; i < [subjectArray count]; i++)
    {
        disciplina = [subjectArray objectAtIndex:i];
        
        if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
        {
            if (addStmt == nil)
            {
                NSString* queryString = [NSString stringWithFormat:@"INSERT INTO T_DISCIPLINA (ID_DISCIPLINA, NM_DISCIPLINA, NM_PROFESSOR, DT_AVD1, DT_AVD2, DT_AVD3, DT_AVD4, DT_SEG_CHAMADA, DT_SEG_CHAMADA_2, DT_FINAL) VALUES (?,?,?,?,?,?,?,?,?,?)"];
                const char *query = [queryString UTF8String];
                
                if (sqlite3_prepare_v2(database, query, -1, &addStmt, NULL) != SQLITE_OK)
                {
                    NSAssert1(0, @"Erro executar query. '%s'", sqlite3_errmsg(database));
                }
                
                else
                {
                    sqlite3_bind_int(addStmt, 1, disciplina.code);
                    sqlite3_bind_text(addStmt, 2, [disciplina.subjectName UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(addStmt, 3, [disciplina.subjectTeacher UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(addStmt, 4, [[NSString stringWithFormat:@"%@", disciplina.avd1Date] UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(addStmt, 5, [[NSString stringWithFormat:@"%@", disciplina.avd2Date] UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(addStmt, 6, [[NSString stringWithFormat:@"%@", disciplina.avd3Date] UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(addStmt, 7, [[NSString stringWithFormat:@"%@", disciplina.avd4Date] UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(addStmt, 8, [[NSString stringWithFormat:@"%@", disciplina.finalDate] UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(addStmt, 9, [[NSString stringWithFormat:@"%@", disciplina.segChamDate] UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(addStmt, 10, [[NSString stringWithFormat:@"%@", disciplina.segChamDate2] UTF8String], -1, SQLITE_TRANSIENT);
                    
                    if (sqlite3_step(addStmt) == SQLITE_DONE)
                    {
                        NSLog(@"OK");
                    }
                    
                    else
                    {
                        NSLog(@"ERROR . '%s'", sqlite3_errmsg(database));
                    }
                    sqlite3_reset(addStmt);
                    addStmt = nil;
                }
            }
            else
            {
                NSLog(@"NOT NILL . '%s'", sqlite3_errmsg(database));
            }
        }
        else
        {
            NSLog(@"ERROR . '%s'", sqlite3_errmsg(database));
        }
    }
}

@end
