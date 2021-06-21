//
//  Library.h
//  RevealControllerProject
//
//  Created by Lucas Rocha on 12/01/14.
//
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface Library : NSObject

@property (nonatomic, readwrite) NSInteger code;
@property (nonatomic, readwrite) NSString* bookName;
@property (nonatomic, readwrite) NSDate* lendDate;
@property (nonatomic, readwrite) NSDate* devolutionDate;

+ (NSMutableArray* ) getLendedBooks: (NSString* )dbPath;
+ (BOOL) insertLendedBooks: (NSString* )dbPath livros:(NSMutableArray* )livros;

@end
