//
//  User.h
//  RevealControllerProject
//
//  Created by Lucas Rocha on 31/12/13.
//
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface User : NSObject
{
    NSData* studentPhoto;
    NSInteger studentId;
    NSString* studentCode;
    NSString* studentToken;
    NSString* studentName;
    NSInteger courseId;
    NSString* courseName;
    NSString* periodName;
    NSInteger periodCode;

}

@property(nonatomic, readwrite) NSData* studentPhoto;
@property(nonatomic, readwrite) NSString* studentCode;
@property(nonatomic, readwrite) NSString* studentToken;
@property(nonatomic, readwrite) NSString* studentName;
@property(nonatomic, readwrite) NSString* courseName;
@property(nonatomic, readwrite) NSString* periodName;
@property(nonatomic, readwrite) NSInteger courseId;
@property(nonatomic, readwrite) NSInteger studentId;
@property(nonatomic, readwrite) NSInteger periodCode;

//DATABASE METHODS
@property (nonatomic, readwrite) BOOL isDirty;
@property (nonatomic, readwrite) BOOL isDetailViewHydrated;

+ (User* )getUserDetais:(NSString* )dbPath studentCode:(NSString*)StudentCode studentPassword:(NSString *)studentPassword;
+ (void) updateUserData:(NSString*) dbPath usuario:(User *)usuario userCode:(NSString* )userCode userId:(NSInteger)userId;
+ (BOOL) checkLoggedUser:(NSString*)dbPath;

@end