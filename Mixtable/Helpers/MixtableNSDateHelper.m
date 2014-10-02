//
//  MixtableNSDateHelper.m
//  Mixtable
//
//  Created by Wessam Abdrabo on 11/26/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import "MixtableNSDateHelper.h"

@implementation MixtableNSDateHelper

//Extracts HH:MM form JSON time format
//(ex: 2000-01-01T13:11:44Z -> 13:11)
+(NSString *)hoursFromJSONTime:(NSString*)JSONTime{
    if(!JSONTime || JSONTime.length < 16)
        return JSONTime;
    return [JSONTime substringWithRange:NSMakeRange(11, 5)];
}

//Converts string date to NSDate with given dateFormat
+(NSDate *) nsDateFromDateString:(NSString*)dateString :(NSString*) dateFormat{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [df setDateFormat:dateFormat];
    return [df dateFromString: dateString];
}

//Gets weekday from Date String
+(NSString*) weekdayFromNSDate:(NSDate*)date{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *weekdayComponents = [gregorian components:(NSDayCalendarUnit | NSWeekdayCalendarUnit) fromDate:date];
    NSInteger weekday = [weekdayComponents weekday];
    return [self weekdayStrFromNSInteger:weekday];
}

//Gets day from Date String
+(NSString*) dayFromNSDate:(NSDate*)date{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *weekdayComponents = [gregorian components:(NSDayCalendarUnit | NSWeekdayCalendarUnit) fromDate:date];
    NSInteger day = [weekdayComponents day];
    return [NSString stringWithFormat:@"%i", day];
}

//converts weekday int to weekday str
+(NSString*) weekdayStrFromNSInteger:(NSInteger)weekday{
    NSArray * weekdays = [NSArray arrayWithObjects: @"Sun", @"Mon", @"Tues", @"Wed", @"Thurs", @"Fri", @"Sat", nil];
    return [weekdays objectAtIndex:weekday-1];
}

+(BOOL) isTime24HFormat:(NSString*) time{
    NSString* hrs_24 = [time substringWithRange:NSMakeRange(0,2)];
    int hrs_int = [hrs_24 integerValue];
    if(hrs_int == 0 || hrs_int == 00 || hrs_int > 12)
        return true;
    return false;
}

//checks if time is 24HRs and converts it to 12hrs
+(NSString*) time24HrsToTime12Hrs:(NSString*)time{
    if([self isTime24HFormat:time]){
        NSString* hrs_24 = [time substringWithRange:NSMakeRange(0,2)];
        int hrs_int = [hrs_24 integerValue];
        
        if(hrs_int == 0 || hrs_int == 00)
            hrs_int = 12;
        
        else if(hrs_int > 12)
            hrs_int -= 12;
        return [NSString stringWithFormat:@"%i",hrs_int];
    }
    return time;
}

//return AM or PM
+(NSString*) timeOfDayFromTime:(NSString*)time{
    return [self isTime24HFormat:time] ? @"PM" : @"AM";
}

/* is same day . ignore time*/
+ (BOOL)isSameDay:(NSDate*)date1 otherDay:(NSDate*)date2 {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}
@end
