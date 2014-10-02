//
//  MixtableNotificationsViewController.m
//  Mixtable
//
//  Created by Wessam Abdrabo on 11/17/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import "MixtableNotificationsViewController.h"
#import "MixtableBasicSettingsViewController.h"
#import "MixtableAppDelegate.h"


@interface MixtableNotificationsViewController ()
@property  NSMutableDictionary* configNotificationDict;
@property  NSMutableArray* userNotificationList;
@property  NSString *configFilePath;
@property  NSString *userNotificationsFilePath;

- (void)reloadTable;
@end
@implementation MixtableNotificationsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(notificationReceived:)
                                                     name:@"registerNotification"
                                                   object:nil];
        [self initNotificationsPlists];
    }
    return self;
}

- (void)initNotificationsPlists {
    _configFilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    _userNotificationsFilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    _configFilePath = [_configFilePath stringByAppendingPathComponent:@"Mixtable-Notifications-Config.plist"];
    _userNotificationsFilePath = [_userNotificationsFilePath stringByAppendingPathComponent:@"Mixtable-Notifications.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:_configFilePath]) {
        NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"Mixtable-Notifications-Config" ofType:@"plist"];
        [fileManager copyItemAtPath:sourcePath toPath:_configFilePath error:nil];
        // create a new property list for users notifications
        sourcePath = [[NSBundle mainBundle] pathForResource:@"Mixtable-Notifications" ofType:@"plist"];
        [fileManager copyItemAtPath:sourcePath toPath:_userNotificationsFilePath error:nil];
    }
    // Load the Property List.
    _configNotificationDict = [[NSMutableDictionary alloc] initWithContentsOfFile:_configFilePath];
    _userNotificationList = [[NSMutableArray alloc] initWithContentsOfFile:_userNotificationsFilePath];
    if(_userNotificationList.count == 0) {
        _userNotificationList = [[NSMutableArray alloc]init];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        
    }
    //init counter
    _notificationCounter = [_userNotificationList count];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadTable)
                                                 name:@"reloadData"
                                               object:nil];
}

- (void) notificationReceived:(NSNotification *) notification
{
    NSString *notificationType = [[notification userInfo] objectForKey:@"type"];
    
    if ([[notification name] isEqualToString:@"registerNotification"])
        NSLog (@"Notification is successfully received! %@",notificationType);
    NSMutableDictionary* temp = [[NSMutableDictionary alloc] initWithDictionary:[_configNotificationDict objectForKey:notificationType]];
    if([notificationType isEqualToString:@"welcomeNotification"]) {
        //replace string
        NSString* msg = [temp objectForKey:@"msg"];
        NSRange range = NSMakeRange([msg rangeOfString:@"["].location, [@"FirstName" length] +2);
        
        msg = [msg stringByReplacingCharactersInRange:range withString:[[MixtableUserDataManager  sharedManager] getFirstName]];
        NSLog(@"%@",msg);
        [temp setObject:msg forKey:@"msg"];
    }
    
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:10];
    localNotification.alertBody = [temp objectForKey:@"msg"];
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:localNotification.applicationIconBadgeNumber];
    _notificationCounter = _notificationCounter + 1;
    [_userNotificationList insertObject:temp atIndex:0];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"updateNotificationIcon"
     object:self
     ];
    [_userNotificationList writeToFile:_userNotificationsFilePath atomically:YES];
    // Request to reload table view data
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
}

- (void)reloadTable
{
    [self.notificationsTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.notificationCounter;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (nil == cell)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
	}
    
    /*customize cell */
    [cell.textLabel setNumberOfLines:3];
    [cell.textLabel setFont: [UIFont fontWithName:@"Nunito-bold" size:12]];
    
    if(_userNotificationList.count == 0){
        return cell;
    }
    
    //check notification type
    if ([[[_userNotificationList objectAtIndex:indexPath.row] objectForKey:@"type"]
         isEqualToString:@"INFO"] && [[[_userNotificationList objectAtIndex:indexPath.row] objectForKey:@"active"] boolValue] == YES ) {
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
    }else if([[[_userNotificationList objectAtIndex:indexPath.row] objectForKey:@"type"]
              isEqualToString:@"ACTION_REQUIRED"] && [[[_userNotificationList objectAtIndex:indexPath.row] objectForKey:@"active"] boolValue] == YES ){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else {
        [cell.textLabel setFont: [UIFont fontWithName:@"Nunito-Regular" size:12]];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    // Display notification info
    [cell.textLabel setText:[[_userNotificationList objectAtIndex:indexPath.row]objectForKey:@"msg"]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int row = [indexPath row];
    [self goTo:row];
    //update notification counter
    if([[[_userNotificationList objectAtIndex:row] objectForKey:@"active"] boolValue]== YES){
        int count = [[UIApplication sharedApplication] applicationIconBadgeNumber] - 1;
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:count];
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"updateNotificationIcon"
         object:self
         ];
    }
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell.textLabel setFont: [UIFont fontWithName:@"Nunito-Regular" size:12]];
    cell.accessoryType = UITableViewCellAccessoryNone;
    [[_userNotificationList objectAtIndex:row] setObject:[NSNumber numberWithBool:NO] forKey:@"active"];
    [_userNotificationList writeToFile:_userNotificationsFilePath atomically:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

-(void)goTo:(int)index {
    NSDictionary* selectedRowDict = [_userNotificationList objectAtIndex:index] ;
    if([[selectedRowDict objectForKey:@"type"] isEqualToString:@"ACTION_REQUIRED"] && [[selectedRowDict objectForKey:@"active"] boolValue]== YES){
        if ([[selectedRowDict objectForKey:@"event"] isEqualToString:@"GOTO_PREF"]) {
            MixtableBasicSettingsViewController *basicSettingsViewController = [[MixtableBasicSettingsViewController alloc] init];
            /* Navigation to details view controller. Should get the reference to the frontviewcontroller NOT from app delegate!!*/
            MixtableAppDelegate *appDelegate = (MixtableAppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate.frontNavController pushViewController:basicSettingsViewController animated:YES];
        }
    }
    
    
}
@end
