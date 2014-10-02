//
//  MixtableSegementedControlCell.h
//  Mixtable
//
//  Created by Muhammad on 03/12/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MultiSelectSegmentedControl.h"
#import "MixtableCell.h"

@interface MixtableSegementedControlCell : MixtableCell
@property (strong, nonatomic) IBOutlet UILabel *cellTitle;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) IBOutlet MultiSelectSegmentedControl *multiSegmentedControl;

@end
