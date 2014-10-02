//
//  MixtableLoginViewController.m
//  Mixtable
//
//  Created by Wessam Abdrabo on 11/11/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import "MixtableLoginViewController.h"
#import "MixtableAppDelegate.h"
#import "MixtableFBLoginManager.h"
#import "MixtableAPIClient.h"
#import "MixtableTutorialViewController.h"
#import "UIImage+ImageEffects.h"
#import "MixtableUserDataManager.h"
#import "Reachability.h"

@interface MixtableLoginViewController ()

@end

@implementation MixtableLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    UIImage *blurredImage = [self getDarkBlurredImageWithTargetView:self.loginView];
    if (blurredImage) {
        [self.bgImageView setImage:blurredImage];
    }
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageController.dataSource = self;
    
    MixtableTutorialViewController *initialViewController = [self viewControllerAtIndex:0];
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self adjustUIForDisplay];
    
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
    [self.view bringSubviewToFront:self.loginBtn];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//###############################
# pragma page view contoller methods
//###############################

- (MixtableTutorialViewController *)viewControllerAtIndex:(NSUInteger)index {
    MixtableTutorialViewController *childViewController = [[MixtableTutorialViewController alloc] initWithNibName:@"MixtableTutorialViewController" bundle:nil];
    childViewController.index = index;
    [childViewController loadTutorialView];
    return childViewController;
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [(MixtableTutorialViewController *)viewController index];
    if (index == 0) {
        return nil;
    }
    
    // Decrease the index by 1 to return
    index--;
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(MixtableTutorialViewController *)viewController index];
    index++;
    
    if (index == 5) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
    
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return 5;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}

//###############################
# pragma facebook login
//###############################

- (IBAction)doLogin:(id)sender {
    MixtableUserDataManager *userDataManager = [MixtableUserDataManager sharedManager];
    
    /* check reachbility first time user logs in*/
    BOOL userExists = YES;
    BOOL isConnected = [self checkReachability];
    
    /* get user email to check if user exists*/
    MixtableUser *user = [userDataManager loadUserFromPlist];
    if(user.email == nil)
        userExists = NO;
    else if(![user.email length])
        userExists = NO;
    
    /* if no internet connection in first login, show alert and stop from entering app*/
    if(isConnected == NO && userExists == NO){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Facebook Login Failed!"
                              message:@"Please check your internet connection and try again."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }else{
        if([userDataManager userFirstLogin]){
            [self.view addSubview:self.overlayView];
        }
        else{
            MixtableFBLoginManager* FBLoginManager = [MixtableFBLoginManager sharedManager];
            [FBLoginManager openSession];
        }
    }
}

- (void)loginFailed{
    // User switched back to the app without authorizing. Stay here, but
    // stop the spinner.
    //[self.spinner stopAnimating];
}

- (IBAction)continueLogin:(id)sender{
    
    MixtableFBLoginManager* FBLoginManager = [MixtableFBLoginManager sharedManager];
    [FBLoginManager setFirstLogin:NO]; //user already accepted T&Cs. Not first login.
    [FBLoginManager openSession];
    [self.overlayView removeFromSuperview];
}

- (IBAction)cancelLogin:(id)sender{
    [self.overlayView removeFromSuperview];
}

//###############################
# pragma checking internet connectivity
//###############################
-(BOOL) checkReachability{
    Reachability* reachability = [Reachability reachabilityWithHostName:@"google.com"];
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    
    if(remoteHostStatus == NotReachable)
        return NO;
    if (remoteHostStatus == ReachableViaWWAN)
        return YES;
    if (remoteHostStatus == ReachableViaWiFi)
        return YES;
    return YES;
}

//###############################
# pragma ui adjustment
//###############################
- (void)adjustUIForDisplay
{
    CGFloat screenHeight = [[UIScreen mainScreen]bounds].size.height;
    
    if(screenHeight == 480){ //3.5 inch
        [self.loginBtn setFrame:CGRectMake(self.loginBtn.frame.origin.x,  screenHeight - self.loginBtn.frame.size.height - 30, self.loginBtn.frame.size.width, self.loginBtn.frame.size.height)];
        
        [[self.pageController view] setFrame:CGRectMake(0, 35, [[self view] bounds].size.width, 430)];
        
        [self.landingBgImageView setImage:[UIImage imageNamed:@"bg-iphone4.jpg"]];
        
    }else{ //4 inch
        [self.loginBtn setFrame:CGRectMake(self.loginBtn.frame.origin.x,  screenHeight - self.loginBtn.frame.size.height - 55, self.loginBtn.frame.size.width, self.loginBtn.frame.size.height)];
        
        [[self.pageController view] setFrame:CGRectMake(0, 80, [[self view] bounds].size.width, 350)];
        [self.landingBgImageView setImage:[UIImage imageNamed:@"bg-iphone5.jpg"]];
        
    }
}

//###############################
# pragma blurred image effect
//###############################
- (UIImage*)getDarkBlurredImageWithTargetView:(UIView *)targetView
{
    CGSize size = targetView.frame.size;
    
    UIGraphicsBeginImageContext(size);
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(c, 0, 0);
    [targetView.layer renderInContext:c]; // view is the view you are grabbing the screen shot of. The view that is to be blurred.
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [image applyDarkEffect];
}
@end
