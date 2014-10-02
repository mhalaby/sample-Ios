//
//  MixtableAppDelegate.m
//  Mixtable
//
//  Created by Wessam Abdrabo on 10/26/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import "MixtableAppDelegate.h"
#import "MixtableMenuViewController.h"

@interface MixtableAppDelegate()<SWRevealViewControllerDelegate>
@end

@implementation MixtableAppDelegate

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation{
    if(!self.FBLoginManager)
        self.FBLoginManager = [MixtableFBLoginManager sharedManager];
    return [self.FBLoginManager handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
     
    self.FBLoginManager = [MixtableFBLoginManager sharedManager];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    MixtableMenuViewController *menuViewController = [[MixtableMenuViewController alloc] init];
    [menuViewController registerFacebookNotification];
    
    self.swipeNavViewController = [[MixtableSwipeNavViewController alloc]
                               initWithNibName:@"MixtableSwipeNavViewController" bundle:nil];
    
    self.frontNavController = [[UINavigationController alloc]
                          initWithRootViewController:self.swipeNavViewController];
    
    self.rearNavController = [[UINavigationController alloc] initWithRootViewController:menuViewController];
	
	SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:nil frontViewController:self.frontNavController];
    
    revealController.delegate = self;
    
    
    revealController.rightViewController = self.rearNavController;
      
    self.mainViewController = revealController;
    
    self.window.rootViewController = self.mainViewController;
    [self.window makeKeyAndVisible];
    
    // See if the app has a valid token for the current state.
    if ([self.FBLoginManager hasValidToken]) {
        [self.FBLoginManager openSession];
    } else {
        // No, display the login page.
        [self.FBLoginManager showLoginView];
    }
    
    self.manager = [MixtableUserDataManager sharedManager];
    self.manager.apiClient = [[MixtableAPIClient alloc] init];
    self.manager.apiClient.delegate = self.manager;

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [self.manager updateUser:self.manager.user];

}

- (void)applicationDidEnterBackground:(UIApplication *)application{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self.manager updateUser:self.manager.user];
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    /* notify dashboard to refresh events if needed */
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"MixtableRefreshEventsNotification"
     object:self
     ];

}

- (void)applicationDidBecomeActive:(UIApplication *)application{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    // We need to properly handle activation of the application with regards to Facebook Login
    // (e.g., returning from iOS 6.0 Login Dialog or from fast app switching).
    [self.FBLoginManager handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{

}
@end
