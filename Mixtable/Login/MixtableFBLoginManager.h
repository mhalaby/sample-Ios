//
//  MixtableFBLoginManager.h
//  Mixtable
//
//  Singleton class for managing Facebook login operations.
//
//  Created by Wessam Abdrabo on 11/12/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MixtableUser.h"
@interface MixtableFBLoginManager : NSObject
@property (strong, nonatomic) MixtableUser *user;

+ (id) sharedManager;
- (void) openSession;
- (void) closeSession;
- (BOOL) hasValidToken;
- (void) handleDidBecomeActive;
- (BOOL) handleOpenURL:(NSURL*)url;
- (void) showLoginView;
- (void) logout;
- (BOOL) isActiveSessionOpen;
-(void) setFirstLogin:(BOOL)firstLogin;
-(void) refreshFacebookInfo;
@end
