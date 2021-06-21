//
//  Auth.h
//  RevealControllerProject
//
//  Created by Lucas Rocha on 24/04/14.
//
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface Auth : NSObject

@property(nonatomic, readwrite) NSString* idUsua;
@property(nonatomic, readwrite) NSString* matriculaUsua;
@property(nonatomic, readwrite) NSString* tokenUsua;

+ (Auth* ) Authenticate:(NSString*) matricula senha:(NSString* )senha;
+ (Auth* ) getLoggedUserCredentials:(NSString*) dbPath;
+ (void) logOff;

+ (void) cleanNewsData:(NSString*)dbPath;
+ (void) cleanBooksData:(NSString*)dbPath;
+ (void) cleanEventData:(NSString*)dbPath;
+ (void) cleanReportData:(NSString*)dbPath;

@end
