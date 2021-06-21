//
//  Util.m
//  RevealControllerProject
//
//  Created by Lucas Rocha on 14/04/14.
//
//

#import "Util.h"

@implementation Util

+ (NSDate* ) stringToDate: (NSString* ) stringDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-mm-dd hh:MM:ss"];
    NSDate* date = [[NSDate alloc] init];
    date = [dateFormatter dateFromString:stringDate];
    return date;
}

@end
