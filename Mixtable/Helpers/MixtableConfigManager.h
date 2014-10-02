//
//  MixtableConfigManager.h
//  Mixtable
//
//  Created by Wessam Abdrabo on 4/26/14.
//  Copyright (c) 2014 Mixtable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MixtableConfigManager : NSObject
+ (id)sharedInstance;
-(NSString*) getTwitterPageURL;
-(NSString*) getContactEmail;
-(NSString*) getContactNumber;
-(NSString*) getMixpicsPageURL;
-(NSString*) getFAQPageURL;
-(NSString*) getTnCsPageURL;
-(NSString*) getPaymillActiveMode;
-(NSString*) getPaymillPublicKey;
-(NSString*) getFBPageID;
-(NSString*)getPaymentAmount;
-(NSString*)getAPIUrl;
@end
