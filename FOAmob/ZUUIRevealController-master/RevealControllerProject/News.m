//
//  News.m
//  RevealControllerProject
//
//  Created by Lucas Rocha on 29/12/13.
//
//

#import "News.h"

static sqlite3 *database = nil;
static sqlite3_stmt *addStmt = nil;

@implementation News

@synthesize isDetailViewHydrated, isDirty, newsId, newsDate, newsAuthor, newsText;

+ (NSMutableArray*) getUserNews:(NSString* )dbPath
{
    //AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSMutableArray* newsArray = [[NSMutableArray alloc] init];
    
	if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        
        NSString* meuSelect =  [NSString stringWithFormat:@"SELECT ID_NOTICIA, DT_PUBLICACAO, NM_AUTOR, TX_CHAMADA FROM T_NOTICIA ORDER BY ID_NOTICIA DESC"];
        
		const char *sql = [meuSelect UTF8String];
        
		sqlite3_stmt *selectstmt;
		if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK)
        {
			while(sqlite3_step(selectstmt) == SQLITE_ROW)
            {
                NSInteger primaryKey = sqlite3_column_int(selectstmt, 0);
                
                News* newsObject = [[News alloc] initWithPrimaryKey:primaryKey];
                
                //data, sim jovem pra trazer uma data só assim....
                NSString* dateString = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 1)];
                dateString = [dateString substringWithRange:NSMakeRange(0, 10)];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"dd-mm-yyyy"];
                newsObject.newsDate = [dateFormatter dateFromString:dateString];
                //fim da maracutaia pra trazer data...
                
                newsObject.newsAuthor = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 2)];
                newsObject.newsText = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 3)];
                
                [newsArray addObject:newsObject];
            }
        }
        else
        {
            NSLog(@"No data found");
            NSAssert1(0, @"ERROR . '%s'", sqlite3_errmsg(database));
        }
        sqlite3_finalize(selectstmt);
    }
    sqlite3_close(database);
    
    return newsArray;
}

+ (NSDate *)getLastNewsDate
{
    return 0;
}

- (id) initWithPrimaryKey:(NSInteger) pk
{
	//[self init];
	newsId = pk;
	
	isDetailViewHydrated = NO;
	
    return self;
}

+ (void) insertUserNews:(NSString* )dbPath noticias:(NSMutableArray* )noticias
{
    News* varNews = [[News alloc] init];
    addStmt = nil;
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        if(addStmt == nil)
        {
            for (int i = 0; i < [noticias count]; i++)
            {
                varNews = [noticias objectAtIndex:i];
                NSString* stringStmt = [NSString stringWithFormat:@"INSERT INTO T_NOTICIA (DT_PUBLICACAO, NM_AUTOR, TX_CHAMADA) VALUES (?,?,?)"];
                
                const char *sql = [stringStmt UTF8String];
                
                if(sqlite3_prepare_v2(database, sql, -1, &addStmt, NULL) != SQLITE_OK)
                {
                    NSLog(@"ERRO - INSERT T_NOTICIA - SQLITE3_PREPARE_V2: '%s'", sqlite3_errmsg(database));
                }
                
                sqlite3_bind_text(addStmt, 1, [[NSString stringWithFormat:@"%@",varNews.newsDate] UTF8String], -1,SQLITE_TRANSIENT);
                sqlite3_bind_text(addStmt, 2, [varNews.newsAuthor UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(addStmt, 3, [varNews.newsText UTF8String], -1, SQLITE_TRANSIENT);
                
                if (sqlite3_step(addStmt) == SQLITE_DONE)
                {
                    NSLog(@"INSERT T_NOTICIA OK");
                }
            
                else
                {
                    NSLog(@"ERRO - INSERT T_NOTICIA - SQLITE3_PREPARE_V2: '%s'", sqlite3_errmsg(database));
                }
                sqlite3_reset(addStmt);
            }
        }
        else
        {
            NSAssert1(0, @"ERROR . '%s'", sqlite3_errmsg(database));
        }
        sqlite3_close(database);
    }
    else
    {
        NSLog(@"ERRO - INSERT T_NOTICIA - SQLITE_OPEN: '%s'", sqlite3_errmsg(database));
    }
}

@end
