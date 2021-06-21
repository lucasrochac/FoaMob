//
//  SyncData.h
//  RevealControllerProject
//
//  Created by Lucas Rocha on 29/12/13.
//
//

#import <Foundation/Foundation.h>

@interface SyncData : NSObject

@property (nonatomic, readwrite) NSDictionary* dict;
@property (nonatomic, readwrite) NSMutableArray* array;

+ (void) startSync:(NSString *)matricula lastSyncDate:(NSDate *)lastSyncDate token:(NSString *)token idUsua:(NSInteger)idUsua;
- (void) syncNews: (NSString *) matricula lastSyncDate:(NSDate*)lastSyncDate token:(NSString*)token;
- (void) syncEvents: (NSString *) matricula lastSyncDate:(NSDate*)lastSyncDate token:(NSString*)token;
- (void) syncReport: (NSString *) matricula lastSyncDate:(NSDate*)lastSyncDate token:(NSString*)token;
- (void) syncBooks: (NSString *) matricula lastSyncDate:(NSDate*)lastSyncDate token:(NSString*)token;
- (void) syncSubject: (NSString *) matricula lastSyncDate:(NSDate*)lastSyncDate token:(NSString*)token;

+ (void) syncOnlyNews: (NSString *) matricula lastSyncDate:(NSDate*)date token:(NSString*)token;
+ (void) syncOnlyEvents: (NSString *) matricula lastSyncDate:(NSDate*)date token:(NSString*)token;
+ (void) syncOnlyReport: (NSString *) matricula lastSyncDate:(NSDate*)date token:(NSString*)token;
+ (void) syncOnlyBooks: (NSString *) matricula lastSyncDate:(NSDate*)date token:(NSString*)token;

@end
