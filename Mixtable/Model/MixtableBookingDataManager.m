//
//  MixtableBookingDataManager.m
//  Mixtable
//
//  Created by Muhammad on 26/11/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import "MixtableBookingDataManager.h"
#import "MixtableModelBuilder.h"
@implementation MixtableBookingDataManager
- (void)fetchBookings
{
    [self.apiClient fetchBookingsUsingAPI];
}


#pragma mark - MixtableAPIClientDelegate

- (void)receivedBookingsJSON:(NSData *)objectNotation
{
    NSError *error = nil;
    NSArray *bookings = [MixtableModelBuilder bookingsFromJSON:objectNotation error:&error];
    
    if (error != nil) {
        [self.delegate fetchingBookingsFailedWithError:error];
        
    } else {
        [self.delegate getBookings:bookings];
    }
}

- (void)fetchingBookingsFailedWithError:(NSError *)error
{
    [self.delegate fetchingBookingsFailedWithError:error];
}


@end
