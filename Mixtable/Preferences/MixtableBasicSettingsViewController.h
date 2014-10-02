//
//  MixtableBasicSettingsViewController.h
//  Mixtable
//
//  Created by Muhammad on 1/12/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MixtableBasePrefrencesViewController.h"

@interface MixtableBasicSettingsViewController : MixtableBasePrefrencesViewController<UIPickerViewDelegate,UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *basicTableView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UIView *footer;
@property (nonatomic, assign) BOOL firstTimeUserFlag;
@property (nonatomic, assign) NSArray* fields;
@property (nonatomic, assign) NSArray* tags;

@property (nonatomic, assign) NSArray* values;
@property (nonatomic, assign) NSString* erro;
@property (strong, nonatomic) UITapGestureRecognizer *tap;
@property(strong, nonatomic) UITextField* editedField;
@end
