//
//  MixtableNotificationsViewController.h
//  Mixtable
//
//  Created by Wessam Abdrabo on 11/17/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MixtableNotificationsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *notificationsTableView;
@property (strong, nonatomic) NSArray *notificationsArray;
@property ( nonatomic) int notificationCounter;

- (void) notificationReceived:(NSNotification *) notification;
@end
