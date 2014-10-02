//
//  MixtableMenuViewController.m
//  Mixtable
//
//  Created by Wessam Abdrabo on 11/24/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import "MixtableMenuViewController.h"
#import "SWRevealViewController.h"
#import "MixtableSwipeNavViewController.h"
#import "MixtableBasicSettingsViewController.h"
#import "MixtableTutorialPageViewController.h"
#import "MixtableTermsViewController.h"
#import "MixtableMixPixViewController.h"
#import "MixtableFAQViewController.h"
#import "MixtableFBLoginManager.h"

#define FBLoginSessionStateChangedNotification @"com.facebook.Mixtable:FBLoginSessionStateChangedNotification"
@interface MixtableMenuViewController (){
    BOOL isUserDataReady;
}
@end

@implementation MixtableMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
	[super viewDidLoad];
    
    [self adjustUIForDisplay];
	
	self.title = NSLocalizedString(@"Menu", nil);
    [self.navigationController setNavigationBarHidden:YES];
    
    //self.FBLoginManager = [MixtableFBLoginManager sharedManager];
    self.userDataManager = [MixtableUserDataManager sharedManager];
    
    if(isUserDataReady){
        NSLog(@"[MenuViewController: ViewDidLoad] populating data");
        [self populateUserDetails];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    BOOL isViewDataEmpty = ![self.nameLabel.text length] || ![self.profileImage.profileID length];
    if(/*isUserDataReady &&*/ isViewDataEmpty){
        NSLog(@"[MenuViewController: ViewDidAppear] populating data ");
        [self populateUserDetails];
    }
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) registerFacebookNotification{
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(setUserDataReady:)
     name:@"com.facebook.Mixtable:FBLoginSessionStateChangedNotification"
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(refreshUserData:)
     name:@"FBDataRefreshed"
     object:nil];
}

//Get user data from facebook
- (void)populateUserDetails{
    if(!self.userDataManager)
        self.userDataManager = [MixtableUserDataManager sharedManager];
    NSString * userName = [self.userDataManager getUserName];
    NSString * profileImageID = [self.userDataManager getProfileImageID];
    
    if(!userName || !profileImageID || [userName length] == 0 || [profileImageID length] == 0){
        MixtableFBLoginManager * FBLoginManager = [MixtableFBLoginManager sharedManager];
        [FBLoginManager refreshFacebookInfo];
    }
    else{
        self.nameLabel.text = userName;
        self.profileImage.profileID = profileImageID;
    }
}
- (void)setUserDataReady:(NSNotification*)notification {
    isUserDataReady = YES;
}

-(void)refreshUserData:(NSNotification*)notification {
    self.nameLabel.text =  [self.userDataManager getUserName];;
    self.profileImage.profileID = [self.userDataManager getProfileImageID];
    [self.nameLabel setNeedsDisplay];
    [self.profileImage setNeedsDisplay];
}

#pragma marl - UITableView Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0)
        return 3;
    if (section == 1)
        return 2;
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *cellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSInteger row = indexPath.row;
	
	if (nil == cell){
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
	}
	if (indexPath.section == 0){
        if (row == 0){
            cell.textLabel.text = @"Mixpics";
        }
        else if (row == 1){
            cell.textLabel.text = @"How it Works";
        }
        else if (row == 2){
            cell.textLabel.text = @"Preferences";
        }
    }else {
        if (row == 0){
            cell.textLabel.text = @"FAQ";
        }
        else if (row == 1){
            cell.textLabel.text = @"Terms and Conditions";
        }
    }
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	// Grab a handle to the reveal controller, as if you'd do with a navigtion controller via self.navigationController.
    SWRevealViewController *revealController = self.revealViewController;
    
    // We know the frontViewController is a NavigationController
    UINavigationController *frontNavigationController = (id)revealController.frontViewController;  // <-- we know it is a NavigationController
    NSInteger row = indexPath.row;
    if (indexPath.section == 0){
        // Here you'd implement some of your own logic... I simply take for granted that the first row (=0) corresponds to the "FrontViewController".
        if (row == 0) /* MixPics */
        {
            if ( ![frontNavigationController.topViewController isKindOfClass:[MixtableTermsViewController class]] )
            {
                MixtableMixPixViewController *mixPicsViewController = [[MixtableMixPixViewController alloc]init];
                [revealController rightRevealToggle:self];
                [frontNavigationController pushViewController:mixPicsViewController animated:NO];
            }
            else
            {
                [revealController rightRevealToggle:self];
            }
        }
        
        else if (row == 1) /* Tutorial */
        {
            if ( ![frontNavigationController.topViewController isKindOfClass:[MixtableTutorialPageViewController class]] )
            {
                
                MixtableTutorialPageViewController *tutorialPageViewController = [[MixtableTutorialPageViewController alloc] init];
                [revealController rightRevealToggle:self];
                [frontNavigationController pushViewController:tutorialPageViewController animated:NO];
            }
            else
            {
                [revealController rightRevealToggle:self];
            }
        }
        else if (row == 2) /* Preferences */
        {
            
            if ( ![frontNavigationController.topViewController isKindOfClass:[MixtableBasicSettingsViewController class]] )
            {
                //VERY DIRTY WORKAROUND
                //add a delay to load data
                double delayInSeconds = 0.70;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    
                    
                    MixtableBasicSettingsViewController *basicSettingsViewController = [[MixtableBasicSettingsViewController alloc] init];
                    [revealController rightRevealToggle:self];
                    [frontNavigationController pushViewController:basicSettingsViewController animated:NO];
                });
            }
            else
            {
                [revealController rightRevealToggle:self];
            }
        }
    }else{
        if (row == 0) /*FAQ*/
        {
            if ( ![frontNavigationController.topViewController isKindOfClass:[MixtableTermsViewController class]] )
            {
                MixtableFAQViewController *faqViewController = [[MixtableFAQViewController alloc]init];
                [revealController rightRevealToggle:self];
                [frontNavigationController pushViewController:faqViewController animated:NO];
            }
            else
            {
                [revealController rightRevealToggle:self];
            }
        }
        else if(row == 1) /*Terms And Conditions */
        {
            if ( ![frontNavigationController.topViewController isKindOfClass:[MixtableTermsViewController class]] )
            {
                MixtableTermsViewController *termsViewController = [[MixtableTermsViewController alloc] init];
                [revealController rightRevealToggle:self];
                [frontNavigationController pushViewController:termsViewController animated:NO];
            }
            else
            {
                [revealController rightRevealToggle:self];
            }
        }
    }
    /*deselect selected rows*/
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
}

- (IBAction)logoutBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    MixtableFBLoginManager *FBLoginManager = [MixtableFBLoginManager sharedManager];
    [FBLoginManager logout];
}
//###############################
# pragma ui adjustment
//###############################
- (void)adjustUIForDisplay
{
    
    CGFloat screenHeight = [[UIScreen mainScreen]bounds].size.height;
    
    [self.logoutBtn setFrame:CGRectMake(self.logoutBtn.frame.origin.x,  screenHeight - self.logoutBtn.frame.size.height -14, self.logoutBtn.frame.size.width, self.logoutBtn.frame.size.height)];
    [self.nameLabel setFrame:CGRectMake(self.nameLabel.frame.origin.x,  screenHeight - self.nameLabel.frame.size.height -15, self.nameLabel.frame.size.width, self.nameLabel.frame.size.height)];
    [self.profileImage setFrame:CGRectMake(self.profileImage.frame.origin.x,  screenHeight - self.profileImage.frame.size.height -10, self.profileImage.frame.size.width, self.profileImage.frame.size.height)];
    [self.view setNeedsDisplay];
    
}
@end
