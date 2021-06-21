//
//  HorarioAula.m
//  FOAMob
//
//  Created by Lucas Rocha on 24/05/14.
//
//

#import "HorarioAula.h"

static sqlite3 *database = nil;
//static sqlite3_stmt* selectstmt = nil;

@implementation HorarioAula

@synthesize hour,idHorario,subjectID,weekDay;

+ (HorarioAula* ) getSubjectHour:(NSString*)dbPath subjectId:(NSInteger) subjectId
{
    HorarioAula* objHorario = [[HorarioAula alloc] init];
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSString* meuSelect =  [NSString stringWithFormat:@"SELECT ID, DIA_SEMANA, HORARIO, DISCIPLINA_ID FROM T_HORARIO_AULA WHERE DISCIPLINA_ID = %i",subjectId];
        
		const char *sql = [meuSelect UTF8String];
        
		sqlite3_stmt *selectstmt;
		if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK)
        {
			while(sqlite3_step(selectstmt) == SQLITE_ROW)
            {
                objHorario.idHorario = sqlite3_column_int(selectstmt, 0);
                objHorario.weekDay = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 1)];
                objHorario.hour = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 2)];
                objHorario.subjectID = sqlite3_column_int(selectstmt, 3);
            }
            
        }
        else
        {
            NSLog(@"ERROR . '%s'", sqlite3_errmsg(database));
        }
        sqlite3_finalize(selectstmt);
    }
    sqlite3_close(database);
    
    return objHorario;
}

@end
