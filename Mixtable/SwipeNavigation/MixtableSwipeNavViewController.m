//
//  MixtableSwipeNavViewController.m
//  Mixtable
//
//  Created by Wessam Abdrabo on 11/17/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import "MixtableSwipeNavViewController.h"
#import "MixtableFBLoginManager.h"
#import "SWRevealViewController.h"

@interface MixtableSwipeNavViewController ()

@end

@implementation MixtableSwipeNavViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(initIcon)
                                                     name:@"updateNotificationIcon"
                                                   object:nil];
    }
    return self;
}
-(void)initIcon {
    UIImage *notificationImg = [UIImage imageNamed:@"Notification.png"];
      UIButton *notificationsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
     NSString *count = [NSString stringWithFormat:@"%d", [[UIApplication sharedApplication] applicationIconBadgeNumber]];
    if ( [[UIApplication sharedApplication] applicationIconBadgeNumber] == 0) {
        notificationImg = nil;
        count = @"";
    }
    [notificationsBtn setBackgroundImage:notificationImg forState:UIControlStateNormal];
   
    [notificationsBtn setTitle:count forState:UIControlStateNormal];
    [notificationsBtn addTarget:self action:@selector(openNotifications:) forControlEvents:UIControlEventTouchDown];
    notificationsBtn.frame = (CGRect) {
        .size.width = 22,
        .size.height = 22,
    };
    UIBarButtonItem *notificationsBtnItem =[[UIBarButtonItem alloc] initWithCustomView:notificationsBtn];
    
    self.navigationItem.leftBarButtonItem = notificationsBtnItem;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray* titles = @[@"Notifications",@"Book a Table",@"Contacts"];
    self.fpnavTitleSwipeView = [[FPNavTitleSwipeView alloc] initWithFrame:CGRectMake(0, 0, 120, 40) titleItems:titles];
    self.fpnavTitleSwipeView.delegate = self;
    [self.fpnavTitleSwipeView setCurrentPageColor:[UIColor redColor]];
    [self.fpnavTitleSwipeView setPageColor:[UIColor lightGrayColor]];
    self.navigationItem.titleView = self.fpnavTitleSwipeView;
    
    
    self.dashboardViewController = [[MixtableDashboardViewController alloc]
initWithNibName:@"MixtableDashboardViewController" bundle:nil];
    
    self.notificationsViewController = [[MixtableNotificationsViewController alloc]
                                        initWithNibName:@"MixtableNotificationsViewController" bundle:nil];
    self.contactsViewController = [[MixtableContactsViewController alloc]
                                   initWithNibName:@"MixtableContactsViewController" bundle:nil];
    
    /* swipe gestures */
    UISwipeGestureRecognizer *dashswipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(scrollForwardDash)];
    dashswipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.dashboardViewController.view addGestureRecognizer:dashswipe];
    UISwipeGestureRecognizer *notificationswipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(scrollForwardNotification)];
    notificationswipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.notificationsViewController.view addGestureRecognizer:notificationswipe];
    UISwipeGestureRecognizer *contactsswipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(scrollForwardContacts)];
    contactsswipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.contactsViewController.view addGestureRecognizer:contactsswipe];
    
    UISwipeGestureRecognizer *dashleftswipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(scrollBackwardDash)];
    dashleftswipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.dashboardViewController.view addGestureRecognizer:dashleftswipe];
    UISwipeGestureRecognizer *notificationleftswipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(scrollBackwardNotification)];
    notificationleftswipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.notificationsViewController.view addGestureRecognizer:notificationleftswipe];
    UISwipeGestureRecognizer *contactsleftswipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(scrollBackwardContacts)];
    contactsleftswipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.contactsViewController.view addGestureRecognizer:contactsleftswipe];
    
    /* slide out menu */
    SWRevealViewController *revealController = [self revealViewController];
    
    /* adds pan gesture to the menu icon but messes up the swipe gesture for the title */
    /*[self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];*/
    
    /* Menu button */
    UIBarButtonItem *menuBtnItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu-icon.png"] style:UIBarButtonItemStyleBordered target:revealController action:@selector(rightRevealToggle:)];
    [menuBtnItem setTintColor:[UIColor whiteColor]];
    
    
    /* Notifications button */
    [self initIcon];
    
    
    self.navigationItem.rightBarButtonItem = menuBtnItem;

    
    /* Navigation styling */
    UIColor * navBarTintColor = [UIColor colorWithRed:61/255.0f green:167/255.0f blue:196/255.0f alpha:1.0f];
    [[UINavigationBar appearance] setBarTintColor:navBarTintColor];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue-Medium" size:20], NSFontAttributeName,[UIColor whiteColor], NSForegroundColorAttributeName, nil];
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
    
    /* if not set, saturation of bar will be less on phone */
    self.navigationController.navigationBar.translucent = NO;
    
    [self.view addSubview:self.dashboardViewController.view];
}


-(void)titleViewChange:(int)page {
    int newpage = page+1;
    if(newpage == 2){
        for(UIView *subview in self.view.subviews){
            if(subview)
                [subview removeFromSuperview];
        }
        [UIView transitionWithView:self.view
                          duration:0.23
                           options:UIViewAnimationOptionTransitionCrossDissolve // animation
                        animations:^ { [self.view addSubview:self.dashboardViewController.view]; }
                        completion:nil];
        //[self.view addSubview:self.dashboardViewController.view];
    }
    else if(newpage == 3){
        for(UIView *subview in self.view.subviews){
            if(subview)
                [subview removeFromSuperview];
        }
        [UIView transitionWithView:self.view
                          duration:0.23
                           options:UIViewAnimationOptionTransitionCrossDissolve // animation
                        animations:^ { [self.view addSubview:self.contactsViewController.view]; }
                        completion:nil];
        //[self.view addSubview:self.contactsViewController.view];
    }
    else if(newpage == 1){
        for(UIView *subview in self.view.subviews){
            if(subview)
                [subview removeFromSuperview];
        }
        [UIView transitionWithView:self.view
                          duration:0.23
                           options:UIViewAnimationOptionTransitionCrossDissolve // animation
                        animations:^ { [self.view addSubview:self.notificationsViewController.view]; }
                        completion:nil];
        //[self.view addSubview:self.notificationsViewController.view];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) openNotifications:(id)sender{
    [self.fpnavTitleSwipeView scrollToNotifications];
}
-(void) scrollForwardDash{
    [self.fpnavTitleSwipeView scrollForward];
}

-(void) scrollBackwardDash{
    [self.fpnavTitleSwipeView scrollBackward];
}
-(void) scrollForwardNotification{
    [self.fpnavTitleSwipeView scrollForward];
}

-(void) scrollBackwardNotification{
    [self.fpnavTitleSwipeView scrollBackward];
}
-(void) scrollForwardContacts{
    [self.fpnavTitleSwipeView scrollForward];
}

-(void) scrollBackwardContacts{
    [self.fpnavTitleSwipeView scrollBackward];
}

@end
