//
//  Event.h
//  RevealControllerProject
//
//  Created by Lucas Rocha on 01/03/14.
//
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface Event : NSObject

@property(nonatomic, retain) NSString* Description;
@property(nonatomic, retain) NSDate* Date;
@property(nonatomic, retain) NSMutableArray* eventArray;

+ (NSMutableArray* ) getEventFromEvent:(NSString* )dbPath;
+ (NSMutableArray* ) getEventData: (NSString* )dbPath;
+ (void) getEventFromSubject:(NSString* )dbPath;
+ (void) getEventFromLendedBooks:(NSString* )dbPath;

+ (void) insertEvent: (NSString* )dbPath Event:(NSMutableArray* ) evento;

@end
