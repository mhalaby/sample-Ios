//
//  MixtableBasePrefrencesViewController.m
//  Mixtable
//
//  Created by Muhammad on 22/12/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import "MixtableBasePrefrencesViewController.h"

#import "MixtableBasicSettingsViewController.h"
#import "MixtablePersonalSettingsViewController.h"
#import "MixtableMixingSettingsViewController.h"
static NSString *userOldEmail;
@interface MixtableBasePrefrencesViewController ()<MixtableUserDataManagerDelegate>{
}

@end
@implementation MixtableBasePrefrencesViewController
@synthesize userDataManager = _userDataManager;
- (void)viewDidLoad:(UITableView*)basicTableView footer:(UIView*)footer setSelectedSegment:(int)selectedSegment
{
    [super viewDidLoad];
    if(selectedSegment == 2) {
     _nextBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"Done"  style:UIBarButtonItemStyleBordered target:self action:@selector(done:)];
    }else {
      _nextBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"Next"  style:UIBarButtonItemStyleBordered target:self action:@selector(nextPage:)];
    }
    _backBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"  style:UIBarButtonItemStyleBordered target:self action:@selector(prevPage:)];
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = _nextBtnItem;
    self.navigationItem.leftBarButtonItem = _backBtnItem;
    self.navigationItem.title = @"Preferences";
    [self.progressBar setTintColor:[UIColor colorWithRed:61/255.0f green:167/255.0f blue:196/255.0f alpha:1.0f]];
    _userDataManager = [MixtableUserDataManager sharedManager];
    if (_userDataManager.user.firstTime != YES) {
        [self createNavSegmentedItems:basicTableView footer:footer setSelectedSegment:selectedSegment];
        _backBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"  style:UIBarButtonItemStyleBordered target:self action:@selector(goToDashboard:)];
        self.navigationItem.leftBarButtonItem = _backBtnItem;
        
    }
    _userDataManager.apiClient = [[MixtableAPIClient alloc] init];
    _userDataManager.apiClient.delegate=_userDataManager;
    _userDataManager.delegate = self;

   if([[UIScreen mainScreen] bounds].size.height == 568)
   {
       [basicTableView setFrame:CGRectMake(0, basicTableView.frame.origin.y, basicTableView.frame.size.width,560)] ;
       [footer setFrame:CGRectMake(0, 460, footer.frame.size.width,footer.frame.size.height)] ;
   }else {
       [basicTableView setFrame:CGRectMake(0, basicTableView.frame.origin.y, basicTableView.frame.size.width,565)] ;
   }
    
}

-(void)createNavSegmentedItems:(UITableView*)basicTableView footer:(UIView*)footer setSelectedSegment:(int)selectedSegment{
    UIColor* navBarColor = [UIColor colorWithRed:(61/255.0) green:(167/255.0) blue:(196/255.0) alpha:1];
    self.navigationItem.rightBarButtonItem= nil;
    self.view.backgroundColor = basicTableView.backgroundColor;
    footer.hidden = YES;
    CGRect bounds = [basicTableView frame];
    [basicTableView setFrame:CGRectMake(bounds.origin.x,
                                    bounds.origin.y,
                                    bounds.size.width,
                                    0)];

    //navigation bar border overwrite
    UIView *navBorder = [[UIView alloc] initWithFrame:CGRectMake(0,self.navigationController.navigationBar.frame.size.height-1,self.navigationController.navigationBar.frame.size.width, 1.3)];
    [navBorder setBackgroundColor:navBarColor];
    [navBorder setOpaque:YES];
    [self.navigationController.navigationBar addSubview:navBorder];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width, 45)];
    [headerView sizeToFit];
    _segment = [[UISegmentedControl alloc] initWithItems:@[@"Basic", @"Personal", @"Mixing"]];
    //styling
    [_segment setBackgroundColor:navBarColor];
    [_segment setTintColor:[UIColor whiteColor]];
    _segment.frame = CGRectMake(10, 5, self.navigationController.navigationBar.frame.size.width-20, 35);
    [headerView addSubview:_segment];
    [self.view addSubview:headerView];
    [headerView setBackgroundColor:navBarColor];
    [_segment addTarget:self action:@selector(chooseView:) forControlEvents:UIControlEventValueChanged];
    [_segment setSelectedSegmentIndex:selectedSegment];
    
}

-(void)chooseView:(UISegmentedControl *)segment{
    UINavigationController *navController = self.navigationController;
    if(segment.selectedSegmentIndex == 0)
    {
        if (self.validate) {
            MixtableBasicSettingsViewController*basicViewController =   [[MixtableBasicSettingsViewController alloc] init];
            [navController pushViewController:basicViewController animated:NO];
            [self save:_userDataManager.user];
        }

    }
    else if(segment.selectedSegmentIndex == 1)
    {
        if (self.validate) {
            MixtablePersonalSettingsViewController *personalViewController = [[MixtablePersonalSettingsViewController alloc] init];
            [navController pushViewController:personalViewController animated:NO];
            [self save:_userDataManager.user];
        }
    }
    else if(segment.selectedSegmentIndex == 2)
    {
      if (self.validate) {
          MixtableMixingSettingsViewController *mixingViewController =  [[MixtableMixingSettingsViewController alloc] init];
          [navController pushViewController:mixingViewController animated:NO];
          [self save:_userDataManager.user];
      }
    }
   
}

-(void)save:(MixtableUser*) user{
    [_userDataManager saveUserToPlist:user];
    [_userDataManager updateUser:user];
}
-(void)goToDashboard:(id)sender{
    //TODO: user creation action
    UINavigationController *navController = self.navigationController;
    [navController popToRootViewControllerAnimated:NO];
    [self save:_userDataManager.user];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"MixtableRedrawCityNotification"
     object:self
     ];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //GAP BETWEEN PREF BAR AND FIELDS
    if(section == 0 && _userDataManager.user.firstTime == YES)
    {
        return 20;
    }else  if(section == 0 && _userDataManager.user.firstTime == NO)
    {
        return 60;
    }
    return 1;
}

- (void)getUsers:(NSArray *)users{}
- (void)getUserByEmail:(MixtableUser *)user{}
- (void)fetchingUsersFailedWithError:(NSError *)error{}
- (void)creatingUserFailed:(NSError *)error{}
- (void)updatingUserFailed:(NSError *)error{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"We can't update your profile, there is no internet connection" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
//    [alert show];
}

-(bool)validate{
    NSArray* validationFields = [NSArray arrayWithObjects:@"first_name",@"last_name",@"email",@"city", nil];
    for (NSString* field in validationFields) {
        NSString* value = [_userDataManager.user valueForKey:field];
        if(value != (id)[NSNull null]) {
            if (value == nil ||[value isEqualToString:@""]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please fill in all the fields" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
                [alert show];
                [_segment setSelectedSegmentIndex:0];
                return NO;
            } else if ([field isEqualToString:@"email"] && ![self isValidEmail:[_userDataManager.user valueForKey:@"email"]]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Invalid Email Address" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
                [alert show];
                [_segment setSelectedSegmentIndex:0];
                return NO;

            }
        }
    }
    [self didEmailChanged];
    return YES;
}
- (void) setOldEmail:(NSString *)oldEmail {
    userOldEmail = oldEmail;
}
/*when a user changes the email, a new record should be added with the user's data*/
-(void)didEmailChanged {
    if(![_userDataManager.user.email isEqualToString:userOldEmail]){
        [_userDataManager createUser:_userDataManager.user];
        userOldEmail = _userDataManager.user.email;
    }

}

#pragma Validate email
-(BOOL) isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

@end
