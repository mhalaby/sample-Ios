//
//  MixtableEventsFactory.m
//  Mixtable
//
//  Created by Wessam Abdrabo on 12/21/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import "MixtableEventsFactory.h"

typedef enum {
    SUNDAY = 1,
    MONDAY,
    TUESDAY,
    WEDNESDAY,
    THURSDAY,
    FRIDAY,
    SATURDAY
}WeekDays;

#define EVENTS_TIME @"20:00"

@interface MixtableEventsFactory()
@property(strong, nonatomic) NSDate* nextWednesday;
@property(strong, nonatomic) NSDate* nextThursday;
@property(strong, nonatomic) NSDate* followingWednesday;
@property(strong, nonatomic) NSDate* followingThursday;
@end

@implementation MixtableEventsFactory

+ (id)sharedInstance {
    static MixtableEventsFactory *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        self.nextWednesday = [[NSDate alloc]init];
        self.nextThursday = [[NSDate alloc]init];
        self.followingWednesday = [[NSDate alloc]init];
        self.followingThursday = [[NSDate alloc]init];
    }
    return self;
}

/* Creates events for Wednesday and Thursday of this week and next week */
-(void) createComingEvents
{
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *today = [NSDate date];
    
    NSDateComponents *timeComponents = [gregorian components: NSUIntegerMax fromDate: today];
    [timeComponents setHour: 22]; // to be set to 20:00 
    [timeComponents setMinute: 0];
    [timeComponents setSecond: 0];
    
    NSDate *date = [gregorian dateFromComponents: timeComponents];
    
    NSDateComponents *weekdayComponents = [gregorian components:NSWeekdayCalendarUnit fromDate:date];
    NSInteger todayWeekday = [weekdayComponents weekday];
    
    NSInteger daysTillWednes = WEDNESDAY-todayWeekday;
    if (daysTillWednes<=0)
        daysTillWednes+=7;
    
    NSDateComponents *WednesComponents = [NSDateComponents new];
    WednesComponents.day = daysTillWednes;
    
    NSInteger daysTillThurs = THURSDAY-todayWeekday;
    if (daysTillThurs<=0)
        daysTillThurs+=7;
    
    NSDateComponents *ThursComponents = [NSDateComponents new];
    ThursComponents.day = daysTillThurs;
    
    NSCalendar *calendar=[[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
    self.nextWednesday = [calendar dateByAddingComponents:WednesComponents toDate:date options:0];
    self.nextThursday = [calendar dateByAddingComponents:ThursComponents toDate:date options:0];
    self.followingWednesday = [self.nextWednesday dateByAddingTimeInterval:60*60*24*7];
    self.followingThursday = [self.nextThursday dateByAddingTimeInterval:60*60*24*7];
}

- (NSDate*) getNextWednesday
{
    
    return self.nextWednesday;
}
- (NSDate*) getNextThursday
{
    
    return self.nextThursday;
}
- (NSDate*) getFollowingWednesday
{
    
    return self.followingWednesday;
}
- (NSDate*) getFollowingThursday
{
    
    return self.followingThursday;
}

/* fixed to 8 pm */
- (NSString*) getEventsTime
{
    return EVENTS_TIME;
}
@end
