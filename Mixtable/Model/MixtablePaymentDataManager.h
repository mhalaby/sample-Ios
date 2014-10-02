//
//  MixtablePaymentDataManager.h
//  Mixtable
//
//  Created by Muhammad on 20/03/14.
//  Copyright (c) 2014 Mixtable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MixtableAPIClient.h"
#import "MixtableDataManager.h"
#import "MixtableAPIClientDelegate.h"
#import "MixtablePayment.h"
#import "MixtablePaymentDataManagerDelegate.h"
@interface MixtablePaymentDataManager : MixtableDataManager<MixtableAPIClientDelegate>
@property(strong, nonatomic) MixtableAPIClient* apiClient;
@property (weak, nonatomic) id<MixtablePaymentDataManagerDelegate> delegate;

- (void)createPayment:(MixtablePayment*)payment;
@end
