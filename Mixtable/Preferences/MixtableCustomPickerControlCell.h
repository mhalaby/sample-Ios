//
//  MixtablePickerControlCell.h
//  Mixtable
//
//  Created by Muhammad on 17/12/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "V8HorizontalPickerView.h"
#import "MixtableCell.h"

@interface MixtableCustomPickerControlCell : MixtableCell<V8HorizontalPickerViewDelegate, V8HorizontalPickerViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *cellTitle;
@property (strong, nonatomic) IBOutlet V8HorizontalPickerView *picker;
@property (strong, nonatomic) NSMutableArray *pickerElements;

@end
