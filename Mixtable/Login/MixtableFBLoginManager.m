//
//  MixtableFBLoginManager.m
//  Mixtable
//
// Singleton class for managing Facebook login operations.
//
//  Created by Wessam Abdrabo on 11/12/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import "MixtableFBLoginManager.h"
#import <FacebookSDK/FacebookSDK.h>
#import "MixtableAppDelegate.h"
#import "MixtableLoginViewController.h"
#import "MixtableUserDataManager.h"
#define FBLoginSessionStateChangedNotification @"com.facebook.Mixtable:FBLoginSessionStateChangedNotification"

@interface MixtableFBLoginManager() <MixtableUserDataManagerDelegate>{
    MixtableUserDataManager* _manager;
}
@end

@implementation MixtableFBLoginManager
+ (id)sharedManager {
    static MixtableFBLoginManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (id)init {
    if (self = [super init]) {
    }
    return self;
}
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error{
    
    MixtableAppDelegate *appDelegate = (MixtableAppDelegate *)[[UIApplication sharedApplication] delegate];
    switch (state) {
        case FBSessionStateOpen: {
            UIViewController *topViewController =
            [appDelegate.rearNavController topViewController];
            if ([[topViewController presentedViewController]
                 isKindOfClass:[MixtableLoginViewController class]]) {
                [topViewController dismissViewControllerAnimated:YES completion:nil];
            }
        }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            // Once the user has logged in, we want them to
            // be looking at the root view.
            [appDelegate.rearNavController popToRootViewControllerAnimated:NO];
            
            [FBSession.activeSession closeAndClearTokenInformation];
            
            [self showLoginView];
            break;
        default:
            break;
    }
    
    if (error) {
        NSLog(@"[MixtableFBLoginManager] Facebook Error: %@", error.localizedDescription);
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Login Error"
                                  message:@"Please check your connection and try again."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)openSession{
    [FBSession openActiveSessionWithReadPermissions:@[@"email"]
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session,
       FBSessionState state, NSError *error) {
         [self sessionStateChanged:session state:state error:error];
         if(state != FBSessionStateClosed)
             [self populateUserData];
     }];
}

-(BOOL) hasValidToken{
    return FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded;
}

-(void) handleDidBecomeActive{
    [FBSession.activeSession handleDidBecomeActive];
}

- (BOOL) handleOpenURL:(NSURL*)url{
    return [FBSession.activeSession handleOpenURL:url];
}

//Not very nice to have UI stuff here linked to the APPdelegated! Should Change.
- (void)showLoginView{
    MixtableAppDelegate *appDelegate = (MixtableAppDelegate *)[[UIApplication sharedApplication] delegate];
    UIViewController *topViewController = [appDelegate.frontNavController topViewController];
    UIViewController *presentedViewController = [topViewController presentedViewController];
    
    // If the login screen is not already displayed, display it. If the login screen is
    // displayed, then getting back here means the login in progress did not successfully
    // complete. In that case, notify the login view so it can update its UI appropriately.
    if (![presentedViewController isKindOfClass:[MixtableLoginViewController class]]) {
        MixtableLoginViewController* loginViewController = [[MixtableLoginViewController alloc]
                                                            initWithNibName:@"MixtableLoginViewController"
                                                            bundle:nil];
        [topViewController presentViewController:loginViewController animated:NO completion:nil];
    } else {
        MixtableLoginViewController* loginViewController =
        (MixtableLoginViewController*)presentedViewController;
        [loginViewController loginFailed]; //kinda does nothing for now!
    }
}

- (void) logout{
    [self closeSession];
}

- (void)closeSession{
    [FBSession.activeSession closeAndClearTokenInformation];
}

//Creat a mixtable user using facebook user data
- (void)populateUserData{
    NSLog(@"[FBLoginManager]: populateUserData...");
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) {
             MixtableUserDataManager *userDataManager = [MixtableUserDataManager sharedManager];
             userDataManager.apiClient = [[MixtableAPIClient alloc] init];
             userDataManager.apiClient.delegate=userDataManager;
             userDataManager.delegate = self;
             if (!error) {
                
                 [userDataManager createUserFromFBUser:user];
                 [self checkemail];
                 [userDataManager getUserByEmail:userDataManager.user.email];
                
                 //Notify Menu
                 [[NSNotificationCenter defaultCenter]
                  postNotificationName:@"com.facebook.Mixtable:FBLoginSessionStateChangedNotification"
                  object:FBSession.activeSession];
                 
             }
             else{
                 NSLog(@"[MixtableFBLoginManager]: error while login!");
                 //offline
                 MixtableUser *user = [userDataManager loadUserFromPlist];
                 [userDataManager updateUserAttributes:user];
             }
         }];
    }
}

/* set First Login to check for accept T&C. Separate from user exits. */
-(void) setFirstLogin:(BOOL)firstLogin{
    MixtableUserDataManager* userDataManager = [MixtableUserDataManager sharedManager];
    if(!firstLogin)
        [userDataManager saveFirstLoginToPlist:@"NO"];
}

#pragma mark - MixtableUserDataManager

-(void)createUserAndNotify:(MixtableUserDataManager*) userDataManager{
    userDataManager.user.firstTime = YES;
    //RESET NOTIFICATIONS
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    NSDictionary* type = [NSDictionary dictionaryWithObject:@"completePrefNotification"
                                                     forKey:@"type"];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"registerNotification"
     object:self
     userInfo:type];
    
    NSDictionary*  welcomeType = [NSDictionary dictionaryWithObject:@"welcomeNotification"
                                                             forKey:@"type"];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"registerNotification"
     object:self
     userInfo:welcomeType];
    //Create a user
    [userDataManager createUser:userDataManager.user];
    [userDataManager saveUserToPlist:userDataManager.user];
    
    NSLog(@"[MixtableFBLoginManager]: User: %@ %@",userDataManager.user.gender,userDataManager.user.last_name);
}

///LOGIC OF THE LOGIN---IF USER IS ALREADY IN DB LOAD THE USER'S DATA OTHERWISE CREATE USER IN DB
- (void)getUserByEmail:(MixtableUser *)user
{
    MixtableUserDataManager *userDataManager = [MixtableUserDataManager sharedManager];
    userDataManager.user.firstTime = NO;
    //userDataManager.user= user;
    [userDataManager updateUserAttributes:user];
    [userDataManager saveUserToPlist:userDataManager.user];
    
    NSLog(@"[MixtableFBLoginManager]: %@ %@",userDataManager.user.gender,userDataManager.user.last_name);
}
//if fetching a user failed, get the data from the user-plist
-(void)fetchingUsersFailedWithError:(NSError *)error{
    MixtableUserDataManager *userDataManager = [MixtableUserDataManager sharedManager];
    //in case offline and the user alread exist
    if ([userDataManager userExits])
    {
        MixtableUser *user = [userDataManager loadUserFromPlist];
        [userDataManager updateUserAttributes:user];
    }else {
        [self createUserAndNotify:userDataManager];
    }
}
- (BOOL) isActiveSessionOpen{
    return FBSession.activeSession.isOpen;
}
/* check if user email from facebook is the same as the one from plist, if so use the one from plist*/
-(void)checkemail{
    MixtableUserDataManager *userDataManager = [MixtableUserDataManager sharedManager];
    
    if (![[userDataManager getUserIDFromPlist]isEqualToString:@"" ] &&
        ![[userDataManager getUserIDFromPlist] isEqualToString:[userDataManager getEmail]] ){
        userDataManager.user.email = [userDataManager getUserIDFromPlist];
    }
}
- (void)getUsers:(NSArray *)users{}
- (void)creatingUserFailed:(NSError *)error{
    NSLog(@"[MixtableFBLoginManager]: CREATING USER FAILED %@",error);
    
}
- (void)updatingUserFailed:(NSError *)error{
    NSLog(@"[MixtableFBLoginManager]: UPDATING USER FAILED %@",error);
}

//relaodFacebookInfo: update name and profile image
-(void) refreshFacebookInfo{
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) {
             MixtableUserDataManager *userDataManager = [MixtableUserDataManager sharedManager];
             if (!error) {
                 userDataManager.user.userName = user.name;
                 userDataManager.user.profileImageID = [user objectForKey:@"id"];
                 //Notify Menu
                 [[NSNotificationCenter defaultCenter]
                  postNotificationName:@"FBDataRefreshed"
                  object:FBSession.activeSession];
             }
             else{
                 NSLog(@"[MixtableFBLoginManager]: error while login!");
                 //offline
             }
         }];
    }
}
@end
