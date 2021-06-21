//
//  HourEnum.m
//  RevealControllerProject
//
//  Created by Lucas Rocha on 17/01/14.
//
//

#import "HourEnum.h"

@implementation HourEnum

+ (NSString* ) getHourString: (int)hourCode
{
    switch (hourCode) {
        case 0:
            return @"18:45 - 20:45";
            break;

        case 1:
            return @"21:50 - 22:15";
            break;
            
        case 2:
            return @"18:45 - 22:15";
            break;
            
        default:
            return NULL;
            break;
    }
}

@end
