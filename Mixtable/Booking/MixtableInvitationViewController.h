//
//  MixtableInvitationViewController.h
//  Mixtable
//
//  Created by Wessam Abdrabo on 3/22/14.
//  Copyright (c) 2014 Mixtable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MixtableBooking.h"

@interface MixtableInvitationViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *email1TextField;
@property (weak, nonatomic) IBOutlet UITextField *email2TextField;
@property (weak, nonatomic) IBOutlet NSString *dateTime;
- (id)initWithBooking:(MixtableBooking*)booking;

@end
