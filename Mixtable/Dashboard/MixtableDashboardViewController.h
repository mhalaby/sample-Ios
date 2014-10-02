//
//  MixtableDashboardViewController.h
//  Mixtable
//
//  Created by Wessam Abdrabo on 11/13/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MixtableDashboardViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *dashboardTableView;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIButton *cityButton;
- (IBAction)cityBtnAction:(id)sender;

@end
