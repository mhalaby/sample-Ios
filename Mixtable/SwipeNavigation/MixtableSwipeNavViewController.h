//
//  MixtableSwipeNavViewController.h
//  Mixtable
//
//  Created by Wessam Abdrabo on 11/17/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FPNavTitleSwipeView.h"
#import "MixtableDashboardViewController.h"
#import "MixtableNotificationsViewController.h"
#import "MixtableContactsViewController.h"

@interface MixtableSwipeNavViewController : UIViewController <FPNavTitleSwipeDelegate>
@property (nonatomic,strong) MixtableDashboardViewController *dashboardViewController;
@property (nonatomic,strong) MixtableNotificationsViewController *notificationsViewController;
@property (nonatomic,strong) MixtableContactsViewController *contactsViewController;
@property (nonatomic, strong) FPNavTitleSwipeView* fpnavTitleSwipeView;

@end
