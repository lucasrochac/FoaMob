//
//  News.h
//  RevealControllerProject
//
//  Created by Lucas Rocha on 29/12/13.
//
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface News : NSObject

@property (nonatomic, readwrite) NSInteger newsId;
@property (nonatomic, readwrite) NSString* newsText;
@property (nonatomic, readwrite) NSString* newsAuthor;
@property (nonatomic, readwrite) NSDate* newsDate;

//DATABASE METHODS
@property (nonatomic, readwrite) BOOL isDirty;
@property (nonatomic, readwrite) BOOL isDetailViewHydrated;

+ (NSMutableArray*) getUserNews:(NSString* )dbPath;
+ (void) insertUserNews:(NSString* )dbPath noticias:(NSMutableArray* )noticias;

@end
