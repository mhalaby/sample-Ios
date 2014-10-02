//
//  MixtableNSDateHelper.h
//  Mixtable
//
//  Created by Wessam Abdrabo on 11/26/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MixtableNSDateHelper : NSObject
+(NSString*) hoursFromJSONTime:(NSString*)JSONTime;
+(NSDate*) nsDateFromDateString:(NSString*)dateString :(NSString*) dateFormat;
+(NSString*) weekdayFromNSDate:(NSDate*)date;
+(NSString*) dayFromNSDate:(NSDate*)date;
+(NSString*) weekdayStrFromNSInteger:(NSInteger)weekday;
+(NSString*) time24HrsToTime12Hrs:(NSString*)time24Hrs;
+(NSString*) timeOfDayFromTime:(NSString*)time;
+ (BOOL)isSameDay:(NSDate*)date1 otherDay:(NSDate*)date2;
@end
