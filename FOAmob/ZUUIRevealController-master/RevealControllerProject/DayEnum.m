//
//  DayEnum.m
//  RevealControllerProject
//
//  Created by Lucas Rocha on 17/01/14.
//
//

#import "DayEnum.h"

@implementation DayEnum

+ (NSString* ) getDayString: (int)dayCode
{
    
    switch (dayCode)
    {
        case 0:
            return @"Segunda-Feira";
            break;

        case 1:
            return @"Terça-Feira";
            break;
            
        case 2:
            return @"Quarta-Feira";
            break;
            
        case 3:
            return @"Quinta-Feira";
            break;
            
        case 4:
            return @"Sexta-Feira";
            break;
            
        default:
            return NULL;
            break;
    }
}

+ (NSString* ) getDayAbreviatedString: (int)dayCode
{
    
    switch (dayCode)
    {
        case 0:
            return @"Seg";
            break;
            
        case 1:
            return @"Ter";
            break;
            
        case 2:
            return @"Quar";
            break;
            
        case 3:
            return @"Qui";
            break;
            
        case 4:
            return @"Sex";
            break;
            
        default:
            return NULL;
            break;
    }
}

@end
