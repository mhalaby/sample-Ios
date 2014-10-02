//
//  MixtablePayment.h
//  Mixtable
//
//  Created by Muhammad on 20/03/14.
//  Copyright (c) 2014 Mixtable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MixtablePaymentDataManagerDelegate.h"
@interface MixtablePayment : NSObject
@property (weak, nonatomic) id<MixtablePaymentDataManagerDelegate> delegate;
@property(strong, nonatomic) NSString* userEmail;
@property(strong, nonatomic) NSString* totalAmount;
@property(strong, nonatomic) NSString* currency;
@property(strong, nonatomic) NSString* promotionCodeId;
@property(strong, nonatomic) NSString* dateTime;
@property(strong, nonatomic) NSString* city;
@property(strong, nonatomic) NSString* paymillResponseCode;
@property(strong, nonatomic) NSString* paymillTransactionId;
@property(strong, nonatomic) NSString* paymillPaymentType;
@property(strong, nonatomic) NSString* paymillPayDateTime;
@end
