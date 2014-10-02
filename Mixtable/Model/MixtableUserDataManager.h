//
//  MixtableUserDataManager.h
//  Mixtable
//  Creates a MixtableUser and populates its data from Facebook user data
//  Created by Wessam Abdrabo on 11/24/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MixtableUser.h"
#import <FacebookSDK/FacebookSDK.h>
#import "MixtableAPIClient.h"
#import "MixtableDataManager.h"
#import "MixtableAPIClientDelegate.h"
#import "MixtableBooking.h"

#import "MixtableUserDataManagerDelegate.h"

@interface MixtableUserDataManager : MixtableDataManager
@property(strong, nonatomic) MixtableUser* user;
@property(strong, nonatomic) MixtableAPIClient* apiClient;
@property (weak, nonatomic) id<MixtableUserDataManagerDelegate> delegate;
@property (strong, nonatomic) NSMutableDictionary *plistDict;
@property (strong, nonatomic) NSMutableArray *userBookingsPlist;


+ (id) sharedManager;
- (void) createUserFromFBUser:(NSDictionary<FBGraphUser>*)FBUser;
- (NSString*) getUserName;
- (NSString*) getFirstName;
- (NSString*) getLastName;
- (NSString*) getProfileImageID;
- (NSString*) getEmail;
- (NSString*) getCity;
- (NSString*) getGender;
- (NSString*) getPhone;
- (NSString*) getReligion;
- (NSString*) getState;
- (NSString*) getHeight;
- (NSString*) getTargetAge;
- (NSString*) getTargetVenue;
- (NSString*) getTargetExpectation;
- (NSString*) getTargetConversation;
- (NSString*) getNewsletterAccepted;
- (NSString*) getPreferredLanguages;
- (NSString*) getPreferredGenders;
- (NSString*) getOccupations;
- (NSString*) getEducation;
- (NSString*) getStatus;

- (void) setGender:(NSString*)value;
- (void) setPhone:(NSString*)value;
- (void) setReligion:(NSString*)value;
- (void) setState:(NSString*)value;
- (void) setHeight:(NSString*)value;
- (void) setTargetAge:(NSString*)value;
- (void) setTargetVenue:(NSString*)value;
- (void) setTargetExpectation:(NSString*)value;
- (void) setTargetConversation:(NSString*)value;
- (void) setNewsletterAccepted:(NSString*)value;
- (void) setPreferredLanguages:(NSString*)value;
- (void) setPreferredGenders:(NSString*)value;
- (void) setOccupations:(NSString*)value;
- (void) setEducation:(NSString*)value;
- (void) setStatus:(NSString*)value;

- (void)fetchUsers;
- (void)getUserByEmail:(NSString*)email;
- (void)createUser:(MixtableUser*)user;
- (void)updateUser:(MixtableUser*)user;
- (void)inviteUsers:(MixtableUser*)user guest1:(NSString*)email1 guest2:(NSString*)email2 dateTime:(NSString*)dateTime city:(NSString*)city;
- (BOOL)userExits;
-(void)saveUserToPlist:(MixtableUser*)user;
-(MixtableUser*) loadUserFromPlist;
-(NSString*) getUserIDFromPlist;
-(NSString*) getUserCityFromPlist;
-(void) updateUserAttributes:(MixtableUser*) userWithAttributes;
-(void)saveFirstLoginToPlist:(NSString*)firstLogin;
-(BOOL) userFirstLogin;
-(void)saveCityToPlist:(NSString*)city;
-(void) saveUserBookingsToPlist;
-(void) addUserBooking:(MixtableBooking*)booking;
-(void) loadUserBookingsFromPlist;
-(void) saveUserBookingToPlist:(MixtableBooking*) booking;


@end
