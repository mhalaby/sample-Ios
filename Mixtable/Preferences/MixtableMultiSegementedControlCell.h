//
//  MixtableMulitSegementedControlCell.h
//  Mixtable
//
//  Created by Muhammad El-Halaby on 12/17/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MultiSelectSegmentedControl.h"
#import "MixtableCell.h"

@interface MixtableMultiSegementedControlCell : MixtableCell
@property (strong, nonatomic) IBOutlet UILabel *cellTitle;
@property (strong, nonatomic) IBOutlet MultiSelectSegmentedControl *multiSegmentedControl;

@end
