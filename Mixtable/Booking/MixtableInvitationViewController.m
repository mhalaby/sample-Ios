//
//  MixtableInvitationViewController.m
//  Mixtable
//
//  Created by Wessam Abdrabo on 3/22/14.
//  Copyright (c) 2014 Mixtable. All rights reserved.
//

#import "MixtableInvitationViewController.h"
#import "MixtableUserDataManager.h"
#import "MixtableAPIClient.h"
@interface MixtableInvitationViewController (){
    MixtableBooking* _booking;
}
@end

@implementation MixtableInvitationViewController

- (id)initWithBooking:(MixtableBooking*)booking
{
    self = [super init];
    _booking = [[MixtableBooking alloc]init];
    if(booking){
        _booking.date = booking.date;
        _booking.time = booking.time;
        _booking.city = booking.city;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *nextBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"Done"  style:UIBarButtonItemStyleBordered target:self action:@selector(done:)];
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = nextBtnItem;
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.title = @"Team Mates";}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) done:(id)sender{
    
    NSString *toEmail1 = self.email1TextField.text;
    NSString *toEmail2 = self.email2TextField.text;
    
    //Validate emails and do api call to send
    if(![toEmail1 isEqualToString:@""] || ![toEmail2 isEqualToString:@""]){
        NSString* errorMsg = @"";
        if(![self isValidEmail:toEmail1])
            errorMsg = [errorMsg stringByAppendingString:@"Invalid Friend 1 email."];
        if(![self isValidEmail:toEmail2] )
            errorMsg = [errorMsg stringByAppendingString:@" Invalid Friend 2 email."];
        if(![errorMsg isEqualToString:@""])
            [self showMessage:@"Alert" text:errorMsg];
        else{
            //send emails
           MixtableUserDataManager* _manager = [MixtableUserDataManager sharedManager];
            _manager.apiClient = [[MixtableAPIClient alloc] init];
            _manager.apiClient.delegate=_manager;
            [_manager inviteUsers:_manager.user guest1:toEmail1 guest2:toEmail2 dateTime:[NSString stringWithFormat:@"%@", _booking.date] city:_manager.user.city];
            /* emails, user, event date */
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    else //On sucess, back to dashboard
        [self.navigationController popToRootViewControllerAnimated:YES];
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
#pragma Validate email
-(BOOL) isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}
@end
