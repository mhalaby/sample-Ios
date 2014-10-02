//
//  MixtablePaymentCodeCell.h
//  Mixtable
//
//  Created by Wessam Abdrabo on 12/8/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MixtablePaymentCodeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UITextField *input;
@property (weak, nonatomic) IBOutlet UILabel *validationLabel;

@end
