//
//  MixtableMixingSettingsViewController.h
//  Mixtable
//
//  Created by Wessam Abdrabo on 11/30/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MixtableBasePrefrencesViewController.h"

@interface MixtableMixingSettingsViewController : MixtableBasePrefrencesViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *settingsTableView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UIView *footer;
@end
