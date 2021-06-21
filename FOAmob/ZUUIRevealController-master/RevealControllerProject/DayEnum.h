//
//  DayEnum.h
//  RevealControllerProject
//
//  Created by Lucas Rocha on 17/01/14.
//
//

#import <Foundation/Foundation.h>

@interface DayEnum : NSObject

+ (NSString* ) getDayString: (int)dayCode;
+ (NSString* ) getDayAbreviatedString: (int)dayCode;

@end
