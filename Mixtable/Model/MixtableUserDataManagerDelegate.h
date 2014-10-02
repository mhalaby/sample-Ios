//
//  MixtableUserDataManagerDelegate.h
//  Mixtable
//
//  Created by Muhammad on 25/11/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MixtableUserDataManagerDelegate <NSObject>
- (void)getUsers:(NSArray *)users;
- (void)getUserByEmail:(MixtableUser *)user;
- (void)fetchingUsersFailedWithError:(NSError *)error;
- (void)creatingUserFailed:(NSError *)error;
- (void)updatingUserFailed:(NSError *)error;
- (void)inviteUsers:(MixtableUser*)user guest1:(NSString*)email1 guest2:(NSString*)email2 ;
@end
