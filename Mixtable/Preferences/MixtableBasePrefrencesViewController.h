//
//  MixtableBasePrefrencesViewController.h
//  Mixtable
//
//  Created by Muhammad on 22/12/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MixtableUserDataManager.h"

@interface MixtableBasePrefrencesViewController : UIViewController<UITableViewDelegate,UIAlertViewDelegate>
@property ( nonatomic) IBOutlet UISegmentedControl *segment;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property(nonatomic)IBOutlet  UIBarButtonItem *nextBtnItem;
@property(nonatomic)IBOutlet  UIBarButtonItem *backBtnItem;

@property(nonatomic) MixtableUserDataManager* userDataManager;
-(bool)validate;
-(void)save:(MixtableUser*) user;
-(void)setOldEmail:(NSString*)oldEmail;
-(void)viewDidLoad:(UITableView*)basicTableView footer:(UIView*)footer setSelectedSegment:(int)selectedSegment;
@end
