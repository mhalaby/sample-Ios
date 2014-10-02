//
//  MixtableBookingDataManagerDelegate.h
//  Mixtable
//
//  Created by Muhammad on 26/11/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MixtableBookingDataManagerDelegate <NSObject>
-(void)getBookings:(NSArray *)bookings;
-(void)fetchingBookingsFailedWithError:(NSError *)error;
@end
