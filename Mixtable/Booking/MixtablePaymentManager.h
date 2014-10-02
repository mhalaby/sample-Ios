//
//  MixtablePaymentManager.h
//  Mixtable
//
//  Created by Wessam Abdrabo on 12/8/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MixtablePaymentDataManagerDelegate.h"
#define INIT_MODE_TEST @"test"
#define INIT_MODE_LIVE @"live"

@interface MixtablePaymentManager : NSObject <MixtablePaymentDataManagerDelegate>

/* Blocks */
typedef void (^OnSuccess)(void);
typedef void (^OnFailure)(NSString*);

+ (id)sharedManager;
-(void) performPayment:(NSString*)cardHolder ccn:(NSString*)cardNumber ccExpiryDate:(NSString*)expiryDate cvc:(NSString*)code eventDateTime:(NSDate*)date success:(OnSuccess)paymentSuccess failure:(OnFailure)paymentFailure;
-(BOOL) isInitialized;
-(void) initializePMManager:(NSString*) mode success:(OnSuccess)initSuccess failure:(OnFailure)initFailure;
@end
