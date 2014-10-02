//
//  MixtableMenuViewController.h
//  Mixtable
//
//  Created by Wessam Abdrabo on 11/24/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MixtableFBLoginManager.h"
#import "MixtableUserDataManager.h"
#import <FacebookSDK/FacebookSDK.h>


@interface MixtableMenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) IBOutlet UITableView *menuTableView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet FBProfilePictureView *profileImage;
@property (strong, nonatomic) MixtableFBLoginManager* FBLoginManager;
@property (strong, nonatomic) MixtableUserDataManager* userDataManager;
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;
- (void) registerFacebookNotification;
- (IBAction)logoutBtnAction:(id)sender;
@end
