//
//  MixtablePaymentDataManagerDelegate.h
//  Mixtable
//
//  Created by Muhammad on 20/03/14.
//  Copyright (c) 2014 Mixtable. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MixtablePaymentDataManagerDelegate <NSObject>
- (void)creatingPaymentFailed:(NSError *)error;
@end
