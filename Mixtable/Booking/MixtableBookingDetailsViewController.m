//
//  MixtableBookingDetailsViewController.m
//  Mixtable
//
//  Created by Wessam Abdrabo on 12/1/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import "MixtableBookingDetailsViewController.h"
#import "MixtableNSDateHelper.h"
#import "MixtablePaymentViewController.h"
#import "MixtableBookingCancellationViewController.h"
#import "MixtableCityDataManager.h"

@interface MixtableBookingDetailsViewController ()
@property (strong, nonatomic) MixtableBooking *booking;
@end

@implementation MixtableBookingDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithBooking:(MixtableBooking*)booking
{
    self = [super init];
    
    if(booking)
        self.booking = booking;
    else
        self.booking = [[MixtableBooking alloc]init];
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dayLabel.text = [MixtableNSDateHelper dayFromNSDate:self.booking.date];
    self.weekDayLabel.text = [MixtableNSDateHelper weekdayFromNSDate:self.booking.date];
    self.timeLabel.text = [MixtableNSDateHelper time24HrsToTime12Hrs:self.booking.time];
    self.timeOfDayLabel.text = [MixtableNSDateHelper timeOfDayFromTime:self.booking.time];
    
    /*Customize Labels. Should be removed from here!!!*/
    self.timeOfDayLabel.font = [UIFont fontWithName:@"Nunito-Regular" size:60];
    self.weekDayLabel.font = [UIFont fontWithName:@"Nunito-Regular" size:35];
    self.dayLabel.font = [UIFont fontWithName:@"Nunito-Regular" size:50];
    self.timeLabel.font = [UIFont fontWithName:@"Nunito-Regular" size:60];
    
    /*custom frame shape for event view. Should be removed from here!!! */
    [self.eventView.layer setCornerRadius:8.0f];
    [self.eventView.layer setMasksToBounds:YES];
    [self.eventView.layer setBorderWidth:2.0f];
    [self.eventView.layer setBorderColor: [[UIColor clearColor] CGColor]];
    
    /* Customization for navigation items. Shouldn't be here!! */
    UIBarButtonItem *nextBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"Confirm"  style:UIBarButtonItemStyleBordered target:self action:@selector(nextPage:)];
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"  style:UIBarButtonItemStyleBordered target:self action:@selector(prevPage:)];
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = nextBtnItem;
    self.navigationItem.leftBarButtonItem = backBtnItem;
    self.navigationItem.title = @"Reserve";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)nextPage:(id)sender
{
    BOOL canDoPayment = [self validateCityStatus];
    if(canDoPayment == YES){
        MixtablePaymentViewController *paymentViewController = [[MixtablePaymentViewController alloc] initWithBooking:self.booking];
        [self.navigationController pushViewController:paymentViewController animated:YES];
    }
}

-(BOOL) validateCityStatus{
    NSString* alertMsg = @"";
    if([self.booking.city.status isEqualToString: CITY_STATUS_RUNNING])
        return YES;
    if([self.booking.city.status isEqualToString: CITY_STATUS_ACTIVE]){
        alertMsg = CITY_STATUS_ACTIVE_MSG;
    }
    if([self.booking.city.status isEqualToString: CITY_STATUS_INACTIVE]){
        alertMsg = CITY_STATUS_INACTIVE_MSG;
    }
    if([alertMsg length] > 0)
        [self showMessage:@"" text:alertMsg];
    return [alertMsg length] > 0 ? NO : YES;
}
-(void)showMessage:(NSString *)title text:(NSString *)text
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:title
                          message:text
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
}
-(void)prevPage:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)cancelBookingActn:(id)sender {
    MixtableBookingCancellationViewController *bookingCancellationViewController = [[MixtableBookingCancellationViewController alloc]init];
    [self. navigationController pushViewController:bookingCancellationViewController animated:YES];
}
@end
