//
//  MixtableBookingDetailsViewController.h
//  Mixtable
//
//  Created by Wessam Abdrabo on 12/1/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MixtableBooking.h"

@interface MixtableBookingDetailsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *weekDayLabel;
@property (strong, nonatomic) IBOutlet UILabel *dayLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeOfDayLabel;
@property (weak, nonatomic) IBOutlet UIView *eventView;
- (id)initWithBooking:(MixtableBooking*)booking;
- (IBAction)cancelBookingActn:(id)sender;
@end
