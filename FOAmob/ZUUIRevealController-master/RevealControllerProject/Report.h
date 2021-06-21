//
//  Report.h
//  RevealControllerProject
//
//  Created by Lucas Rocha on 14/01/14.
//
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface Report : NSObject

@property (nonatomic, readwrite) NSInteger code;
@property (nonatomic, readwrite) NSInteger subjectCode;
@property (nonatomic, readwrite) float avd1;
@property (nonatomic, readwrite) float avd2;
@property (nonatomic, readwrite) float avd3;
@property (nonatomic, readwrite) float avd4;
@property (nonatomic, readwrite) float media;
@property (nonatomic, readwrite) float final;
@property (nonatomic, readwrite) NSInteger numFaltas;
@property (nonatomic, readwrite) float segChamada2;
@property (nonatomic, readwrite) float segChamada;

+ (NSMutableArray*) getReportCard: (NSString* )dbPath;
+ (Report*) getSujectDataById:(NSInteger)subjectCode dbPath:(NSString* )dbPath;
+ (void) insertReportData: (NSString*) dbPath report: (Report* ) report;

@end
