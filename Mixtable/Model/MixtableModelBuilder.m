//
//  MixtableUserBuilder.m
//  Mixtable
//
//  Created by Muhammad on 25/11/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import "MixtableModelBuilder.h"
#import "MixtableUser.h"
#import "MixtableBooking.h"
#import "MixtableNSDateHelper.h"
#define MIXTABLE_USER_PLIST "Mixtable-User.plist"

static id ObjectOrNull(id object)
{
    return object ?: @"";
}
@implementation MixtableModelBuilder

+(NSArray *)usersFromJSON:(NSData *)objectNotation error:(NSError **)error{
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    
    if (localError != nil) {
        *error = localError;
        return nil;
    }
    //----to be removed-----
    NSArray* userSelectors  = [NSArray arrayWithObjects:@"email",@"first_name",nil] ;

    NSMutableArray *users = [[NSMutableArray alloc] init];

    for (NSDictionary *userDic in parsedObject) {
        MixtableUser *user = [[MixtableUser alloc] init];
        for (NSString *key in userSelectors) {
            if ([user respondsToSelector:NSSelectorFromString(key)]) {
                [user setValue:[userDic valueForKey:key] forKey:key];
            }
        }
        [users addObject:user];
    }
    return users;
}

+(MixtableUser *)userFromJSON:(NSData *)objectNotation error:(NSError **)error{
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];

    if (localError != nil) {
        *error = localError;
        return nil;
    }
    //----to be removed-----
    NSArray* userSelectors  = [NSArray arrayWithObjects:@"email",@"first_name",@"last_name",@"gender",@"phone",@"religion",@"city",@"state",@"height",@"target_age",@"target_venue",@"target_expectation",@"target_conversation",@"newsletter_accepted",@"preferred_languages",@"preferred_genders",@"occupations",@"education",nil] ;
    MixtableUser *user = [[MixtableUser alloc] init];
    
        for (NSString *key in userSelectors) {
            if ([user respondsToSelector:NSSelectorFromString(key)]) {
                [user setValue:[parsedObject valueForKey:key] forKey:key];
            }
        }
    
    return user;
}

+(NSArray *)bookingsFromJSON:(NSData *)objectNotation error:(NSError **)error{
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    
    if (localError != nil) {
        *error = localError;
        return nil;
    }
    //----to be removed-----
    NSArray* bookingSelectors  = [NSArray arrayWithObjects:@"date",@"time",nil] ;
    
    NSMutableArray *bookings = [[NSMutableArray alloc] init];
    
    for (NSDictionary *bookingDic in parsedObject) {
        MixtableBooking *booking = [[MixtableBooking alloc] init];
        booking.booked = NO; /* TEMP!! Should change */
        for (NSString *key in bookingSelectors) {
            if ([booking respondsToSelector:NSSelectorFromString(key)]) {
                NSString* value = [bookingDic valueForKey:key];
                if([key isEqualToString:@"time"]){
                     NSString* formattedTime = [MixtableNSDateHelper hoursFromJSONTime:value];
                     [booking setValue:formattedTime forKey:key];
                }else if([key isEqualToString:@"date"]){
                    NSDate* formattedDate = [MixtableNSDateHelper nsDateFromDateString:value :@"yyyy-MM-dd"];
                    [booking setValue:formattedDate forKey:key];
                }
            }
        }
        
        [bookings addObject:booking];
    }
    return bookings;
}

+(NSData*)JSONFromUser:(MixtableUser*) user{
    NSDictionary *newDatasetInfo =@{@"email":ObjectOrNull([user email]),
                                    @"first_name":ObjectOrNull([user first_name]),
                                    @"last_name":ObjectOrNull([user last_name]),
                                    @"gender":ObjectOrNull([user gender]),
                                    @"phone":ObjectOrNull([user phone]),
                                    @"city":ObjectOrNull([user city]),
                                    @"religion":ObjectOrNull([user religion]),
                                    @"state":ObjectOrNull([user state]),
                                    @"height":ObjectOrNull([user height]),
                                    @"target_age":ObjectOrNull([user target_age]),
                                    @"target_venue":ObjectOrNull([user target_venue]),
                                    @"target_expectation":ObjectOrNull([user target_expectation]),
                                    @"target_conversation":ObjectOrNull([user target_conversation]),
                                    @"newsletter_accepted":ObjectOrNull([user newsletter_accepted]),
                                    @"preferred_languages":ObjectOrNull([user preferred_languages]),
                                    @"preferred_genders":ObjectOrNull([user preferred_genders]),
                                    @"education":ObjectOrNull([user education]),
                                    @"occupations":ObjectOrNull([user occupations])};
    
    NSDictionary *userJSON = [NSDictionary dictionaryWithObject:newDatasetInfo forKey:@"user"];
    NSError *error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:userJSON options:kNilOptions error:&error];
    
    NSLog(@"JSON summary: %@", [[NSString alloc] initWithData:jsonData
                                                     encoding:NSUTF8StringEncoding]);
    return jsonData;

}
+(NSData*)createInvitation:(NSString*)user guest1:(NSString*)email1 guest2:(NSString*)email2 dateTime:(NSString*)dateTime city:(NSString*)city{
    NSDictionary *newDatasetInfo =@{@"user_email":ObjectOrNull(user),
                                    @"guest1_email":ObjectOrNull(email1),
                                    @"guest2_email":ObjectOrNull(email2),
                                    @"dateTime":ObjectOrNull(dateTime),
                                    @"city":ObjectOrNull(city)};
    
    NSDictionary *invitationJSON = [NSDictionary dictionaryWithObject:newDatasetInfo forKey:@"invitation"];
    NSError *error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:invitationJSON options:kNilOptions error:&error];
    
    NSLog(@"JSON summary: %@", [[NSString alloc] initWithData:jsonData
                                                     encoding:NSUTF8StringEncoding]);
    return jsonData;
}

+(NSData*)JSONFromPayment:(MixtablePayment*) payment{
    NSDictionary *newDatasetInfo =@{@"user_email":ObjectOrNull([payment userEmail]),
                                    @"total_amount":ObjectOrNull([payment totalAmount]),
                                    @"currency":ObjectOrNull([payment currency]),
                                    @"promotion_code_id":ObjectOrNull([payment promotionCodeId]),
                                    @"date_time":ObjectOrNull([payment dateTime]),
                                    @"city":ObjectOrNull([payment city]),
                                    @"paymill_response_code":ObjectOrNull([payment paymillResponseCode]),
                                    @"paymill_transaction_id":ObjectOrNull([payment paymillTransactionId]),
                                    @"paymill_payment_type":ObjectOrNull([payment paymillPaymentType]),
                                    @"paymill_pay_datetime":ObjectOrNull([payment paymillPayDateTime])};
    
    NSDictionary *paymentJSON = [NSDictionary dictionaryWithObject:newDatasetInfo forKey:@"payment"];
    NSError *error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:paymentJSON options:kNilOptions error:&error];
    
    NSLog(@"JSON summary: %@", [[NSString alloc] initWithData:jsonData
                                                     encoding:NSUTF8StringEncoding]);
    return jsonData;

  }
@end
