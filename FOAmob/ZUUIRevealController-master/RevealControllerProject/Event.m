//
//  Event.m
//  RevealControllerProject
//
//  Created by Lucas Rocha on 01/03/14.
//
//

#import "Event.h"
#import "AppDelegate.h"

static sqlite3 *database = nil;
static sqlite3_stmt *addStmt = nil;

@implementation Event

@synthesize Date,Description,eventArray;

+ (NSMutableArray*) getEventData: (NSString* )dbPath
{
    NSMutableArray* eventObj = [[NSMutableArray alloc] init];

    [eventObj addObjectsFromArray:[Event getEventFromEvent:dbPath]];
    
    return eventObj;
}

+ (void)getEventFromSubject:(NSString* )dbPath
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    NSMutableArray* colunas = [[NSMutableArray alloc] initWithObjects:@"DT_AVD1", @"DT_AVD2",@"DT_SEG_CHAMADA", @"DT_FINAL", nil];
    NSMutableArray* desColunas = [[NSMutableArray alloc] initWithObjects:@"AVD1",@"AVD2",@"Segunda Chamada",@"Prova Final", nil];

    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        for(int i = 0; i < colunas.count; i++)
        {
            NSString* meuSelect =  [NSString stringWithFormat:@"SELECT NM_DISCIPLINA, %@ FROM T_DISCIPLINA",colunas[i]];
    
            NSLog(@"QUERY => %@",meuSelect);
            
            const char *sql = [meuSelect UTF8String];
        
            sqlite3_stmt *selectstmt;
            if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK)
            {
                while(sqlite3_step(selectstmt) == SQLITE_ROW)
                {
                    Event* objEnvet = [[Event alloc] init];

                    NSString* nomdeDisciplina = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 0)];
                
                    NSString* dateString = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 1)];
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
                    
                    objEnvet.Date = [dateFormatter dateFromString:dateString];
                    objEnvet.Description = [NSString stringWithFormat:@"%@ de %@", desColunas[i], nomdeDisciplina];
                
                    NSLog(@"RESULT => %@ - %@",objEnvet.Date, objEnvet.Description);
                        
                    [array addObject:objEnvet];
                }
            }
            else
            {
                NSLog(@"No data found");
            }
            sqlite3_finalize(selectstmt);
        }
        sqlite3_close(database);
        
        [Event insertEvent:[AppDelegate getDBPath] Event:array];
    }
}

+ (void)getEventFromLendedBooks:(NSString* )dbPath
{
    NSMutableArray* array = [[NSMutableArray alloc] init];

    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSString* meuSelect =  [NSString stringWithFormat:@"SELECT NM_LIVRO, DT_ENTREGA FROM T_LIVRO"];
        
        const char *sql = [meuSelect UTF8String];
        
        sqlite3_stmt *selectstmt;
        if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(selectstmt) == SQLITE_ROW)
            {
                Event* objEnvet = [[Event alloc] init];

                NSString* bookName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 0)];
                
                NSString* dateString = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 1)];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-mm-dd"];
                objEnvet.Date = [dateFormatter dateFromString:dateString];
                
                objEnvet.Description = [NSString stringWithFormat:@"Devolver livro: %@", bookName];
                
                [array addObject:objEnvet];
            }
        }
        else
        {
            NSLog(@"No data found");
        }
        sqlite3_finalize(selectstmt);
    }
    sqlite3_close(database);
    
    [Event insertEvent:[AppDelegate getDBPath] Event:array];
}

+ (NSMutableArray* )getEventFromEvent:(NSString* )dbPath
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSString* meuSelect =  [NSString stringWithFormat:@"SELECT NM_EVENTO, DT_EVENTO FROM T_EVENTO ORDER BY DT_EVENTO"];
        
        const char *sql = [meuSelect UTF8String];
        
        sqlite3_stmt *selectstmt;
        if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(selectstmt) == SQLITE_ROW)
            {
                
                Event* objEnvet = [[Event alloc] init];

                objEnvet.Description = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 0)];
                
                NSString* dateString = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 1)];
                dateString = [dateString substringWithRange:NSMakeRange(0, 16)];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"dd-mm-yyyy HH:mm"];
                objEnvet.Date = [dateFormatter dateFromString:dateString];
                
                [array addObject:objEnvet];
            }
        }
        else
        {
            NSLog(@"No data found");
        }
        sqlite3_finalize(selectstmt);
    }
    sqlite3_close(database);
    
    return array;
}

+ (void) insertEvent: (NSString* )dbPath Event:(NSMutableArray* ) eventArray
{
    for (int i = 0; i < eventArray.count; i++)
    {
        NSLog(@"%i", i);
        Event* evento = [[Event alloc]init];
        
        evento = [eventArray objectAtIndex:i];
        
        if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
        {
            if(addStmt == nil)
            {
                const char *sql = "INSERT INTO T_EVENTO (DT_EVENTO, NM_EVENTO) VALUES (?, ?)";
                if(sqlite3_prepare_v2(database, sql, -1, &addStmt, NULL) != SQLITE_OK)
                {
                    NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
                }
                else
                {
                    sqlite3_bind_text(addStmt, 1, [[NSString stringWithFormat:@"%@",evento.Date] UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(addStmt, 2, [evento.Description UTF8String], -1, SQLITE_TRANSIENT);
                }
            }

            if (sqlite3_step(addStmt) == SQLITE_DONE)
            {
                NSLog(@"OK");
            }
        
            else
            {
                NSLog(@"ERROR");
                NSAssert1(0, @"ERROR . '%s'", sqlite3_errmsg(database));

            }
            sqlite3_reset(addStmt);
        }
        else
        {
            NSAssert1(0, @"ERROR . '%s'", sqlite3_errmsg(database));
        }
        sqlite3_close(database);
    }
}

@end
