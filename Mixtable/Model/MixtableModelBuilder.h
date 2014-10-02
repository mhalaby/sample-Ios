//
//  MixtableUserBuilder.h
//  Mixtable
//
//  Created by Muhammad on 25/11/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//
#import "MixtableUser.h"
#import "MixtablePayment.h"

#import <Foundation/Foundation.h>

@interface MixtableModelBuilder : NSObject
+(NSArray *)usersFromJSON:(NSData *)objectNotation error:(NSError **)error;
+(MixtableUser *)userFromJSON:(NSData *)objectNotation error:(NSError **)error;
+(NSArray *)bookingsFromJSON:(NSData *)objectNotation error:(NSError **)error;
+(NSData*)JSONFromUser:(MixtableUser*) user;
+(NSData*)JSONFromPayment:(MixtablePayment*) payment;
+(NSData*)createInvitation:(NSString*)user guest1:(NSString*)email1 guest2:(NSString*)email2 dateTime:(NSString*)dateTime city:(NSString*)city;
@end
