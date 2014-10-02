//
//  MixtablePaymentDataManager.m
//  Mixtable
//
//  Created by Muhammad on 20/03/14.
//  Copyright (c) 2014 Mixtable. All rights reserved.
//

#import "MixtablePaymentDataManager.h"
#import "MixtableModelBuilder.h"

@implementation MixtablePaymentDataManager

- (void)createPayment:(MixtablePayment *)payment{
    [self.apiClient createPaymentUsingAPI:[MixtableModelBuilder JSONFromPayment:payment]];
}

- (void)creatingPaymentFailedUsingAPI:(NSError *)error {
    [self.delegate creatingPaymentFailed:error];
}
@end
