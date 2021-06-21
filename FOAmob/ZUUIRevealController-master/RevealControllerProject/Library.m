//
//  Library.m
//  RevealControllerProject
//
//  Created by Lucas Rocha on 12/01/14.
//
//

#import "Library.h"

static sqlite3 *database = nil;
static sqlite3_stmt *addStmt = nil;

@implementation Library

@synthesize lendDate,code,bookName,devolutionDate;

+ (NSMutableArray* ) getLendedBooks: (NSString* )dbPath
{
    NSMutableArray* livros = [[NSMutableArray alloc] init];
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSString* meuSelect =  [NSString stringWithFormat:@"SELECT ID_EMPRESTIMO, NM_LIVRO, DT_EMPRESTIMO, DT_ENTREGA FROM T_EMPRESTIMO_LIVRO"];
        
		const char *sql = [meuSelect UTF8String];
        
		sqlite3_stmt *selectstmt;
		if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK)
        {
			while(sqlite3_step(selectstmt) == SQLITE_ROW)
            {
                Library* livro = [[Library alloc] init];
                
                livro.code = sqlite3_column_int(selectstmt, 0);
                
                livro.bookName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 1)];
                
                //data, sim jovem pra trazer uma data só assim.... e vou ter que trazer duas dessa vez.. saco!!!
                NSString* dateString = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 2)];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"dd-mm-yyyy"];
                livro.lendDate = [dateFormatter dateFromString:dateString];
                //fim da maracutaia pra trazer data...
                
                //data, sim jovem pra trazer uma data só assim.... e vou ter que trazer duas dessa vez.. saco!!!
                dateString = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 3)];
                livro.devolutionDate = [dateFormatter dateFromString:dateString];
                //fim da maracutaia pra trazer data...

                [livros addObject:livro];
                
                NSLog(@"livro ---- >> %@",livro.bookName);
                NSLog(@"ENTREGA ---- >> %@",livro.devolutionDate);
                NSLog(@"DEVOLVE ---- >> %@",livro.lendDate);
                NSLog(@"==========================================");

            }
        }
        else
        {
            NSLog(@"No data found");
        }
        sqlite3_finalize(selectstmt);
    }
    sqlite3_close(database);
    
    return livros;
}

+ (BOOL) insertLendedBooks: (NSString* )dbPath livros:(NSMutableArray* )livros
{
    addStmt = nil;
    BOOL insert = false;
    Library* varLivro = [[Library alloc] init];
        
        if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
        {
            if(addStmt == nil)
            {
                for (int i = 0; i < [livros count]; i++)
                {
                    varLivro = [livros objectAtIndex:i];
                    
                    NSString* stringStmt = [NSString stringWithFormat:@"INSERT INTO T_EMPRESTIMO_LIVRO (NM_LIVRO, DT_EMPRESTIMO, DT_ENTREGA) VALUES (?, '%@', '%@')", varLivro.lendDate, varLivro.devolutionDate];
                
                
                    const char *sql = [stringStmt UTF8String];
                
                    if(sqlite3_prepare_v2(database, sql, -1, &addStmt, NULL) != SQLITE_OK)
                    {
                        NSLog(@"ERRO - INSERT T_EMPRESTIMO_LIVRO - SQLITE3_PREPARE_V2: '%s'", sqlite3_errmsg(database));
                    }
            
                    sqlite3_bind_text(addStmt, 1, [varLivro.bookName UTF8String], -1, SQLITE_TRANSIENT);
            
                    if (sqlite3_step(addStmt) == SQLITE_DONE)
                    {
                        NSLog(@"INSERT T_EMPRESTIMO_LIVRO OK");
                        insert = true;
                    }
                    else
                    {
                        NSLog(@"ERRO - INSERT T_EMPRESTIMO_LIVRO - SQLITE_DONE '%s'", sqlite3_errmsg(database));
                        insert = false;
                    }
                }
            sqlite3_reset(addStmt);
        }
        else
        {
            NSLog(@"ERRO - INSERT T_EMPRESTIMO_LIVRO - SQLITE3_OPEN '%s'", sqlite3_errmsg(database));
            insert = false;
        }
        sqlite3_close(database);
        
    }
    return insert;
}

@end
