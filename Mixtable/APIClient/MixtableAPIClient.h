//
//  MixtableAPIClient.h
//  Mixtable
//
//  Created by Wessam Abdrabo on 11/16/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MixtableUser.h"
@protocol MixtableAPIClientDelegate;

@interface MixtableAPIClient : NSObject

@property (weak, nonatomic) id<MixtableAPIClientDelegate> delegate;
-(void)fetchUserByEmailUsingAPI:(NSString*)email;
-(void)fetchUsersUsingAPI;
-(void)sendInvitation:(NSData*)jsonData;
-(void)createUserUsingAPI:(NSData*)jsonData;
-(void)updateUserUsingAPI:(NSData*)jsonData email:(NSString*)email;
-(void)createPaymentUsingAPI:(NSData*)jsonData;
-(void)fetchBookingsUsingAPI;
@end

