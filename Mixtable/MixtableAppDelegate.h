//
//  MixtableAppDelegate.h
//  Mixtable
//
//  Created by Wessam Abdrabo on 10/26/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MixtableFBLoginManager.h"
#import "MixtableSwipeNavViewController.h"
#import "SWRevealViewController.h"
#import "MixtableUserDataManager.h"

@interface MixtableAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController* frontNavController;
@property (strong, nonatomic) UINavigationController* rearNavController;
@property (strong, nonatomic) SWRevealViewController *mainViewController;
@property (strong, nonatomic) MixtableSwipeNavViewController *swipeNavViewController;
@property (strong, nonatomic) MixtableFBLoginManager *FBLoginManager;
@property (strong, nonatomic) MixtableUserDataManager *manager;


@end
