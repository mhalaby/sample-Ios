//
//  MixtableSliderCell.h
//  Mixtable
//
//  Created by Muhammad on 03/12/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MixtableCell.h"

@interface MixtableSliderCell : MixtableCell
@property (strong, nonatomic) IBOutlet UILabel *cellTitle;
@property (strong, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) IBOutlet UILabel *maxTitle;
@property (strong, nonatomic) IBOutlet UILabel *minTitle;




@end
