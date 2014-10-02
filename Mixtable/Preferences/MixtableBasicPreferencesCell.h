//
//  MixtablePreferencesCell.h
//  Mixtable
//
//  Created by Muhammad on 02/12/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MixtableCell.h"
@interface MixtableBasicPreferencesCell : MixtableCell
@property (strong, nonatomic) IBOutlet UILabel *cellTitle;
@property (strong, nonatomic) IBOutlet UITextField *cellInput;
@end
