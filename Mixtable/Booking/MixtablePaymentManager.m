//
//  MixtablePaymentManager.m
//  Mixtable
//
//  Created by Wessam Abdrabo on 12/8/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import "MixtablePaymentManager.h"
#import "MixtablePayment.h"
#import "MixtablePaymentDataManager.h"
#import "MixtableUserDataManager.h"
#import "MixtableConfigManager.h"
#import <PayMillSDK/PMSDK.h>

@interface MixtablePaymentManager () <MixtablePaymentDataManagerDelegate>{
    MixtablePaymentDataManager* _manager;
    BOOL isInitialized;
    NSString* publicKey;
    int paymentAmount;
}
@end

@implementation MixtablePaymentManager
+ (id)sharedManager {
    static MixtablePaymentManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (id)init {
    if (self = [super init]) {
        isInitialized = NO;
        publicKey = @"";
        paymentAmount = 15;
        
        _manager = [[MixtablePaymentDataManager alloc] init];
        _manager.apiClient = [[MixtableAPIClient alloc] init];
        _manager.apiClient.delegate=_manager;
        _manager.delegate = self;
        
        //get paymill account public key  and paymnet amount from plist
        MixtableConfigManager *configManager = [MixtableConfigManager sharedInstance];
        publicKey = [configManager getPaymillPublicKey];
        paymentAmount = [[configManager getPaymentAmount]intValue];
    }
    return self;
}

-(void) initializePMManager:(NSString*) mode success:(OnSuccess)initSuccess failure:(OnFailure)initFailure{
    if(isInitialized) //avoid initialization more than once
        initSuccess();
    else{
        /* Paymill initWithTestMode */
        NSLog(@"[MixtablePaymentManager]: Paymill init with mode = %@", mode);
        [PMManager initWithTestMode:([mode isEqualToString:INIT_MODE_TEST] == YES) merchantPublicKey:publicKey newDeviceId:nil init:^(BOOL success, PMError *error) {
            if(success) {
                NSLog(@"[MixtablePaymentManager]: Paymill init success.");
                isInitialized = true;
                initSuccess();
            }
            else {
                isInitialized = false;
                initFailure(@"Check internet connection and try again.");
            }}];
    }
}

-(void) performPayment:(NSString*)cardHolder ccn:(NSString*)cardNumber ccExpiryDate:(NSString*)expiryDate cvc:(NSString*)code eventDateTime:(NSDate*)date success:(OnSuccess)paymentSuccess failure:(OnFailure)paymentFailure{
    NSLog(@"[MixtablePaymentManager]: Perform Payment");
    
    //locals
    
    PMError *error;
    PMPaymentParams *params;
    
    // the payment method (cc or dd data)
    id<PMPaymentMethod> method = [PMFactory genCardPaymentWithAccHolder:cardHolder cardNumber:cardNumber expiryMonth:[expiryDate substringWithRange:NSMakeRange(0,2)] expiryYear:[expiryDate substringWithRange:NSMakeRange(3,4)] verification:code error:&error];
    
    if(!error) {
        // the payment parameters (currency, amount, description)
        MixtableUserDataManager* userDataManager = [MixtableUserDataManager sharedManager];
        NSString* description = [NSString stringWithFormat:@"Booking a Mixtable for  %@ on %@", [userDataManager getEmail], date];
        params =  [PMFactory genPaymentParamsWithCurrency:@"EUR" amount:paymentAmount*100 description:description error:&error];
    } else {
        //handle validation error
        NSLog(@"[MixtablePaymentManager]: PM params error:%@", error.message);
    }
    if(!error) {
        [PMManager transactionWithMethod:method parameters:params consumable:NO
                                 success:^(PMTransaction *transaction) {
                                     // transaction successfully created
                                     NSLog(@"[MixtablePaymentManager]: PM Transaction:%@", transaction.id);
                                     
                                     /* save payment to DB */
                                     MixtableUserDataManager* userDataManager = [MixtableUserDataManager sharedManager];
                                     MixtablePayment *payment = [[MixtablePayment alloc] init];
                                     payment.userEmail = [userDataManager getEmail];
                                     payment.city = [userDataManager getCity];
                                     payment.totalAmount = transaction.amount;
                                     payment.currency = transaction.currency;
                                     payment.promotionCodeId = @"";
                                     payment.dateTime = [NSString stringWithFormat:@"%@", date ? date : [NSDate date]];
                                     payment.paymillTransactionId = transaction.id;
                                     payment.paymillPaymentType = transaction.payment.type;
                                     payment.paymillResponseCode = [NSString stringWithFormat:@"%d", transaction.response_code];
                                     payment.paymillPayDateTime = transaction.payment.created_at;
                                     [_manager createPayment:payment];
                                     NSDictionary* type = [NSDictionary dictionaryWithObject:@"bookingNotification"
                                                                                      forKey:@"type"];
                                     
                                     [[NSNotificationCenter defaultCenter]
                                      postNotificationName:@"registerNotification"
                                      object:self
                                      userInfo:type];
                                     paymentSuccess();
                                 }
                                 failure:^(PMError *error) {
                                     // transaction creation failed
                                     NSLog(@"[MixtablePaymentManager]: PM Error:%@", error.message);
                                     paymentFailure(error.message);
                                 }];
    } else {
        //handle validation error
        NSLog(@"[MixtablePaymentManager]: PM transaction Error:%@", error.message);
    }
}

-(BOOL)isInitialized{
    return isInitialized;
}

/**************************************/
#pragma mark - payment data manager delegate methods
/**************************************/
- (void)creatingPaymentFailed:(NSError *)error{
    // do something
}


@end
