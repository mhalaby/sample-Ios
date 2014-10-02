//
//  MixtableUserDataManager.m
//  Mixtable
//
//  Created by Wessam Abdrabo on 11/24/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import "MixtableUserDataManager.h"
#import "MixtableModelBuilder.h"
#import "MixtableNSDateHelper.h"
#import "MixtableCityDataManager.h"
#define MIXTABLE_USER_PLIST "Mixtable-User.plist"
#define MIXTABLE_USER_BOOKINGS_PLIST "Mixtable-UserBookings.plist"

@interface MixtableUserDataManager(){
    NSArray *searchPaths;
    NSString *docStorePath;
    NSString *dataFilePath;
    NSString* bookingsDataFilePath;
}
@end
@implementation MixtableUserDataManager
+ (id)sharedManager {
    static MixtableUserDataManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (id)init {
    if (self = [super init]) {
        self.user = [[MixtableUser alloc] init];
        searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        docStorePath = [searchPaths objectAtIndex:0];
        /* copy plist only once */
        dataFilePath = [docStorePath stringByAppendingPathComponent:@MIXTABLE_USER_PLIST];
        if(![[NSFileManager defaultManager]fileExistsAtPath:dataFilePath]){
            [[NSFileManager defaultManager]copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"Mixtable-User" ofType:@"plist"] toPath:dataFilePath error:nil];
        }
        
        bookingsDataFilePath = [docStorePath stringByAppendingPathComponent:@MIXTABLE_USER_BOOKINGS_PLIST];
        if(![[NSFileManager defaultManager]fileExistsAtPath:bookingsDataFilePath]){
            [[NSFileManager defaultManager]copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"Mixtable-UserBookings" ofType:@"plist"] toPath:bookingsDataFilePath error:nil];
        }
        _plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:dataFilePath];
        _userBookingsPlist = [[NSMutableArray alloc] initWithContentsOfFile:bookingsDataFilePath];
    }
    return self;
}
- (void) createUserFromFBUser:(NSDictionary<FBGraphUser>*)FBUser{
    self.user.userName = FBUser.name;
    self.user.first_name = FBUser.first_name;
    self.user.last_name = FBUser.last_name;
    self.user.email = [FBUser objectForKey:@"email"];
    self.user.profileImageID = [FBUser objectForKey:@"id"];
    self.user.city = [[FBUser.location[@"name"] componentsSeparatedByString:@","] objectAtIndex:0];
    self.user.firstLogin = NO;
    
}
- (NSString*) getUserName{
    return self.user.userName;
}
- (NSString*) getFirstName{
    return self.user.first_name;
}
- (NSString*) getLastName{
    return self.user.last_name;
}
- (NSString*) getProfileImageID{
    return self.user.profileImageID;
}
- (NSString*) getEmail{
    return self.user.email;
}
- (NSString*) getCity{
    return self.user.city;
}

- (NSString*) getGender{
    return self.user.gender;
}
- (NSString*) getPhone{
    return self.user.phone;
}

- (NSString*) getReligion{
    return self.user.religion;
}

- (NSString*) getState{
    return self.user.state;
}

- (NSString*) getHeight{
    return self.user.height;
}

- (NSString*) getTargetAge{
    return self.user.target_age;
}

- (NSString*) getTargetVenue{
    return self.user.target_venue;
}

- (NSString*) getTargetExpectation{
    return self.user.target_expectation;
}

- (NSString*) getTargetConversation{
    return self.user.target_conversation;
}

- (NSString*) getNewsletterAccepted{
    return self.user.newsletter_accepted;
}

- (NSString*) getPreferredLanguages{
    return self.user.preferred_languages;
}

- (NSString*) getPreferredGenders{
    return self.user.preferred_genders;
}

- (NSString*) getOccupations{
    return self.user.occupations;
}

- (NSString*) getEducation{
    return self.user.education;
}

- (NSString*) getStatus{
    return self.user.status;
}

- (void) setGender:(NSString*)value{
    self.user.gender=value;
}
- (void) setPhone:(NSString*)value{
    self.user.phone=value;
}
- (void) setReligion:(NSString*)value{
    self.user.religion=value;
}
- (void) setState:(NSString*)value{
    self.user.state=value;
}
- (void) setHeight:(NSString*)value{
    self.user.height=value;
}
- (void) setTargetAge:(NSString*)value{
    self.user.target_age=value;
}
- (void) setTargetVenue:(NSString*)value{
    self.user.target_venue=value;
}
- (void) setTargetExpectation:(NSString*)value{
    self.user.target_expectation=value;
}
- (void) setTargetConversation:(NSString*)value{
    self.user.target_conversation=value;
}
- (void) setNewsletterAccepted:(NSString*)value{
    self.user.newsletter_accepted=value;
}
- (void) setPreferredLanguages:(NSString*)value{
    self.user.preferred_languages=value;
}
- (void) setPreferredGenders:(NSString*)value{
    self.user.preferred_genders=value;
}
- (void) setOccupations:(NSString*)value{
    self.user.occupations=value;
}
- (void) setEducation:(NSString*)value{
    self.user.education=value;
}
- (void) setStatus:(NSString*)value{
    self.user.status=value;
}
-(void) addUserBooking:(MixtableBooking*)booking{
    if(self.user.bookings == nil)
        self.user.bookings = [[NSMutableArray alloc]init];
    if(booking){
        [self.user.bookings addObject:booking];
        [self saveUserBookingToPlist:booking];
    }
}
- (void)fetchUsers
{
    [self.apiClient fetchUsersUsingAPI];
}
- (void)getUserByEmail:(NSString *)email
{
    [self.apiClient fetchUserByEmailUsingAPI:email];
}
- (void)createUser:(MixtableUser*)user
{
    [self.apiClient createUserUsingAPI:[MixtableModelBuilder JSONFromUser:user]];
}

- (void)updateUser:(MixtableUser*)user
{
    [self.apiClient updateUserUsingAPI:[MixtableModelBuilder JSONFromUser:user] email:user.email];
}

#pragma mark - MixtableAPIClientDelegate
- (void)receivedUsersJSON:(NSData *)objectNotation
{
    NSError *error = nil;
    NSArray *users = [MixtableModelBuilder usersFromJSON:objectNotation error:&error];
    
    if (error != nil) {
        [self.delegate fetchingUsersFailedWithError:error];
        
    } else {
        [self.delegate getUsers:users];
    }
}

-(MixtableUser*) loadUserFromPlist{
    //----to be removed-----
    NSArray* userSelectors  = [NSArray arrayWithObjects:@"email",@"first_name",@"last_name",@"gender",@"phone",@"religion",@"city",@"state",@"height",@"target_age",@"target_venue",@"target_expectation",@"target_conversation",@"newsletter_accepted",@"preferred_languages",@"preferred_genders",@"occupations",@"education",@"firstTime",nil] ;
    MixtableUser *user = [[MixtableUser alloc] init];
    
    for (NSString *key in userSelectors) {
        if ([user respondsToSelector:NSSelectorFromString(key)]) {
            [user setValue:[_plistDict valueForKey:key] forKey:key];
        }
    }
    //[user setValue:[_plistDict valueForKey:@"firstTime"] forKey:@"firstTime"];
    
    return user;
}

/* loads current users booked events from plist */
-(void) loadUserBookingsFromPlist{
    NSMutableArray* userBookings = [[NSMutableArray alloc]init];
    for(NSDictionary* bookingDict in _userBookingsPlist){
        MixtableBooking *booking = [[MixtableBooking alloc]init];
        booking.date = [bookingDict valueForKey:@"date"];
        booking.time = [bookingDict valueForKey:@"time"];
        booking.booked = YES;
        MixtableCity* city = [[MixtableCity alloc]init];
        city.name = [bookingDict valueForKey:@"city"];
        MixtableCityDataManager * cityDataManager = [MixtableCityDataManager sharedInstance];
        city.status = [cityDataManager getCityStatusFromCityName:city.name];
        booking.city = city;
        [userBookings addObject:booking];
    }
    self.user.bookings = userBookings;
}

- (void)receivedUserJSON:(NSData *)objectNotation
{
    NSError *error = nil;
    MixtableUser *user = [MixtableModelBuilder userFromJSON:objectNotation error:&error];
    
    if (error != nil) {
        [self.delegate fetchingUsersFailedWithError:error];
        
    } else {
        [self.delegate getUserByEmail:user];
    }
}
- (void)fetchingUsersFailedWithError:(NSError *)error
{
    [self.delegate fetchingUsersFailedWithError:error];
}

- (void)creatingUserFailedUsingAPI:(NSError *)error {
    [self.delegate creatingUserFailed:error];
}
- (void)updatingUserFailedUsingAPI:(NSError *)error {
    [self.delegate updatingUserFailed:error];
}


- (void)inviteUsers:(MixtableUser*)user guest1:(NSString*)email1 guest2:(NSString*)email2 dateTime:(NSString*)dateTime city:(NSString*)city {
    [self.apiClient sendInvitation:[MixtableModelBuilder createInvitation:user.email guest1:email1 guest2:email2 dateTime:dateTime city:city]];
    
}


-(void)saveFirstLoginToPlist:(NSString*)firstLogin{
    if(firstLogin == nil || ![firstLogin length])
        return;
    
    [_plistDict setValue:firstLogin forKey:@"firstLogin"];
    [_plistDict writeToFile:dataFilePath atomically:NO];
}
-(void)saveCityToPlist:(NSString*)city{
    if(city == nil || ![city length])
        return;
    
    [_plistDict setValue:city forKey:@"city"];
    [_plistDict writeToFile:dataFilePath atomically:NO];
}
/* save user info to plist */
-(void)saveUserToPlist:(MixtableUser*)user{
    
    NSString *firstTime = user.firstTime ? @"YES" : @"NO";
    [_plistDict setValue:user.first_name ? user.first_name : @"" forKey:@"first_name"];
    [_plistDict setValue:user.last_name ? user.last_name : @"" forKey:@"last_name"];
    [_plistDict setValue:user.gender ? user.gender : @"" forKey:@"gender"];
    [_plistDict setValue:user.religion ? user.religion : @"" forKey:@"religion"];
    //[_plistDict setValue:user.state ? user.state : @"" forKey:@"state"];
    [_plistDict setValue:user.height ? user.height : @"" forKey:@"height"];
    [_plistDict setValue:user.target_age ? user.target_age : @"" forKey:@"target_age"];
    [_plistDict setValue:user.target_venue ? user.target_venue : @"" forKey:@"target_venue"];
    [_plistDict setValue:user.target_expectation ? user.target_expectation : @"" forKey:@"target_expectation"];
    [_plistDict setValue:user.target_conversation ? user.target_conversation : @"" forKey:@"target_conversation"];
    [_plistDict setValue:user.preferred_languages ? user.preferred_languages : @"" forKey:@"preferred_languages"];
    [_plistDict setValue:user.preferred_genders ? user.preferred_genders : @"" forKey:@"preferred_genders"];
    [_plistDict setValue:user.occupations ? user.occupations : @"" forKey:@"occupations"];
    [_plistDict setValue:user.education ? user.education : @"" forKey:@"education"];
    [_plistDict setValue:user.status ? user.status : @"" forKey:@"status"];
    [_plistDict setValue:user.email ? user.email : @"" forKey:@"email"];
    [_plistDict setValue:firstTime ? firstTime : @"" forKey:@"firstTime"];
    [_plistDict setValue:user.city ? user.city : @""  forKey:@"city"];
    
    /* NSLog(@"###################################################");
     NSLog(@"PLIST: %@", _plistDict);
     NSLog(@"###################################################");*/
    
    
    BOOL writeResult = [_plistDict writeToFile:dataFilePath atomically:NO];
    NSLog(@"[UserDataManager: saveUserToPlist] writeToFile returns %d", writeResult);
}

/* save user's booking to plist */
-(void) saveUserBookingsToPlist{
    for(MixtableBooking* booking in self.user.bookings){
        if(booking){
            NSMutableDictionary* bookingDict = [[NSMutableDictionary alloc]init];
            [bookingDict setValue:booking.date forKey:@"date"];
            [bookingDict setValue:booking.time forKey:@"time"];
            [bookingDict setValue:booking.city.name forKey:@"city"];
            if(bookingDict){
                [_userBookingsPlist addObject:bookingDict];
            }
        }
    }
    NSLog(@"###################################################");
    NSLog(@"Booking PLIST: %@", _userBookingsPlist);
    NSLog(@"###################################################");
    BOOL writeResult = [_userBookingsPlist writeToFile:bookingsDataFilePath atomically:YES];
    NSLog(@"[UserDataManager: saveUserBookingsToPlist] writeToFile returns %d", writeResult);
}

/* save user's booking to plist */
-(void) saveUserBookingToPlist:(MixtableBooking*) booking{
    if(booking){
        NSMutableDictionary* bookingDict = [[NSMutableDictionary alloc]init];
        [bookingDict setValue:booking.date forKey:@"date"];
        [bookingDict setValue:booking.time forKey:@"time"];
        [bookingDict setValue:booking.city.name forKey:@"city"];
        if(bookingDict){
            [_userBookingsPlist addObject:bookingDict];
        }
    }
    BOOL writeResult = [_userBookingsPlist writeToFile:bookingsDataFilePath atomically:YES];
    NSLog(@"[UserDataManager: saveUserBookingsToPlist] writeToFile result: %d", writeResult);
}

/* return wether user logged in and saved an email */
-(BOOL)userExits{
    NSString *userID = [_plistDict objectForKey:@"email"];
    NSLog(@"[UserExits] userID =  %@, _user.email = %@", userID, _user.email );
    if(userID == nil || ![userID length] || ![userID isEqualToString:_user.email]){
        return NO;
    }
    return YES;
}
-(NSString*) getUserIDFromPlist{
    NSString *userID = [_plistDict objectForKey:@"email"];
    if(userID && [userID length]){
        return userID;
    }
    return @"";
}
-(NSString*) getUserCityFromPlist{
    NSString *userCity = [_plistDict objectForKey:@"city"];
    if(userCity && [userCity length]){
        return userCity;
    }
    return @"";
}

/* check if first time user logs in */
-(BOOL) userFirstLogin{
    NSString *userFirstLogin = [_plistDict objectForKey:@"firstLogin"];
    if([userFirstLogin isEqualToString:@"NO"]){
        return NO;
    }
    return YES;
}

/* set user with attributes fetched from database or plist */
-(void) updateUserAttributes:(MixtableUser*) userWithAttributes{
    self.user.first_name = userWithAttributes.first_name;
    self.user.last_name = userWithAttributes.last_name;
    self.user.email = userWithAttributes.email;
    self.user.city = userWithAttributes.city;
    self.user.gender = userWithAttributes.gender;
    self.user.phone = userWithAttributes.phone;
    self.user.religion = userWithAttributes.religion;
    self.user.state = userWithAttributes.state;
    self.user.height = userWithAttributes.height;
    self.user.target_age = userWithAttributes.target_age;
    self.user.target_venue = userWithAttributes.target_venue;
    self.user.target_expectation = userWithAttributes.target_expectation;
    self.user.target_conversation = userWithAttributes.target_conversation;
    self.user.newsletter_accepted = userWithAttributes.newsletter_accepted;
    self.user.preferred_languages = userWithAttributes.preferred_languages;
    self.user.preferred_genders = userWithAttributes.preferred_genders;
    self.user.occupations = userWithAttributes.occupations;
    self.user.education = userWithAttributes.education;
    self.user.status = userWithAttributes.status;
}


@end
