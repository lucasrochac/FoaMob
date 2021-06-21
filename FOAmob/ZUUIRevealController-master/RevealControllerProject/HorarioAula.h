//
//  HorarioAula.h
//  FOAMob
//
//  Created by Lucas Rocha on 24/05/14.
//
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface HorarioAula : NSObject

@property(nonatomic, readwrite) NSInteger idHorario;
@property(nonatomic, readwrite) NSString* weekDay;
@property(nonatomic, readwrite) NSString* hour;
@property(nonatomic, readwrite) NSInteger subjectID;

+ (HorarioAula *) getSubjectHour:(NSString*)dbPath subjectId:(NSInteger) subjectId;

@end
