//
//  MixtablePaymentViewController.h
//  Mixtable
//
//  Created by Wessam Abdrabo on 12/7/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MixtablePaymentManager.h"
#import "MixtableBooking.h"


@interface MixtablePaymentViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (strong, nonatomic)MixtablePaymentManager *paymentManager;
@property (weak, nonatomic) IBOutlet UITableView *paymentTableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *paymentActivityIndicator;
@property (strong, nonatomic) UITapGestureRecognizer *tap;
@property (weak, nonatomic) IBOutlet UIView *formFooterView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *footerViewHeightConstraint;
- (id)initWithBooking:(MixtableBooking*)booking;

@end
