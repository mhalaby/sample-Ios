//
//  MixtablePickerControlCell.h
//  Mixtable
//
//  Created by Muhammad on 17/12/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MixtableCell.h"
@interface MixtablePickerControlCell : MixtableCell<UIPickerViewDataSource, UIPickerViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *cellTitle;
@property (strong, nonatomic) IBOutlet UIPickerView *picker;
@property (strong, nonatomic) NSMutableArray *pickerElements;
@property (strong, nonatomic) IBOutlet UIScrollView* scrollView;
@end
