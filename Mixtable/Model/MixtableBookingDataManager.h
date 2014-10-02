//
//  MixtableBookingDataManager.h
//  Mixtable
//
//  Created by Muhammad on 26/11/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MixtableAPIClient.h"
#import "MixtableAPIClientDelegate.h"
#import "MixtableBookingDataManagerDelegate.h"
#import "MixtableBooking.h"
#import "MixtableDataManager.h"

@interface MixtableBookingDataManager : MixtableDataManager
@property(strong, nonatomic) MixtableBooking* booking;
@property (weak, nonatomic) id<MixtableBookingDataManagerDelegate> delegate;

- (void)fetchBookings;

@end
