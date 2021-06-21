//
//  Subject.h
//  RevealControllerProject
//
//  Created by Lucas Rocha on 16/01/14.
//
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface Subject : NSObject

@property (nonatomic, readwrite) NSInteger code;
@property (nonatomic, readwrite) NSString* subjectName;
@property (nonatomic, readwrite) NSString* subjectTeacher;
@property (nonatomic, readwrite) NSDate* avd1Date;
@property (nonatomic, readwrite) NSDate* avd2Date;
@property (nonatomic, readwrite) NSDate* avd3Date;
@property (nonatomic, readwrite) NSDate* avd4Date;
@property (nonatomic, readwrite) NSDate* finalDate;
@property (nonatomic, readwrite) NSDate* segChamDate;
@property (nonatomic, readwrite) NSDate* segChamDate2;

+ (NSMutableArray*) getBasicDataToReport: (NSString*)dbPath;
+ (Subject* ) getSubjectDataById: (NSString*)dbPath code:(int)subjectCode;
+ (NSMutableArray*)getSubjectIds:(NSString*) dbPath;
+ (void) insertSubjectData:(NSString *) dbPath subjectArray:(NSMutableArray*) subjectArray;

@end
