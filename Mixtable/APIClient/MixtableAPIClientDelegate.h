//
//  MixtableAPIClientDelegate.h
//  Mixtable
//
//  Created by Muhammad on 25/11/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MixtableAPIClientDelegate <NSObject>
- (void)receivedUserJSON:(NSData *)objectNotation;
- (void)receivedUsersJSON:(NSData *)objectNotation;

- (void)fetchingUsersFailedWithError:(NSError *)error;
- (void)creatingUserFailedUsingAPI:(NSError *)error;
- (void)updatingUserFailedUsingAPI:(NSError *)error;

- (void)creatingPaymentFailedUsingAPI:(NSError *)error;
- (void)sendingInvitationFailedUsingAPI:(NSError *)error;
- (void)receivedBookingsJSON:(NSData *)objectNotation;
- (void)fetchingBookingsFailedWithError:(NSError *)error;
@end
