//
//  MixtablePaymentViewController.m
//  Mixtable
//
//  Created by Wessam Abdrabo on 12/7/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import "MixtablePaymentViewController.h"
#import "MixtablePaymentCardHolderCell.h"
#import "MixtablePaymentCardNumberCell.h"
#import "MixtablePaymentCodeCell.h"
#import "MixtablePaymentExpireDateCell.h"
#import "PMCreditCardTypeParser.h"
#import "MixtableInvitationViewController.h"
#import "MixtableUserDataManager.h"
#import "MixtableConfigManager.h"

@interface MixtablePaymentViewController(){
    BOOL paymentInProgress;
    NSString* paymillMode;
    NSString* paymentCardHolder;
    NSString* paymentCardNumber;
    NSString* paymentExpiryDate;
    NSString* paymentCardCode;
    UITextField* editedField;
    MixtableBooking *_booking;
}
@end

@implementation MixtablePaymentViewController

- (id)initWithBooking:(MixtableBooking*)booking
{
    self = [super init];
    if(self){
        _booking = [[MixtableBooking alloc]init];
        paymentInProgress = NO; //prevent multiple clicks to submit
        if(booking){
            _booking.date = booking.date;
            _booking.time = booking.time;
            _booking.city = booking.city;
        }
        /* get paymill mode from plist */
        MixtableConfigManager *configManager = [MixtableConfigManager sharedInstance];
        paymillMode = [configManager getPaymillActiveMode];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /* Customization for navigation items. Shouldn't be here!! */
    UIBarButtonItem *nextBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"Submit"  style:UIBarButtonItemStyleBordered target:self action:@selector(submit:)];
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"  style:UIBarButtonItemStyleBordered target:self action:@selector(prevPage:)];
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = nextBtnItem;
    self.navigationItem.leftBarButtonItem = backBtnItem;
    self.navigationItem.title = @"Payment";
    
    
    //Adjust ui for screens
    [self adjustUIForDisplay];
    
    //tap gesture recognizer
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    self.tap.enabled = NO;
    [self.view addGestureRecognizer:self.tap];
    
    
    //init payment manager
    self.paymentManager = [MixtablePaymentManager sharedManager];
    
    //init payment fields
    paymentCardNumber = @"";
    paymentCardHolder = @"";
    paymentExpiryDate = @"";
    paymentCardCode = @"";
    
    self.paymentActivityIndicator.hidden = YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)submit:(id)sender
{
    if(paymentInProgress == NO){
        /* dismiss keyboard. Needed otherwise the last edited field value won't be reached */
        [editedField resignFirstResponder];
        
        //Input verification
        if(![self inputVerification]) {
            NSLog(@"[MixtablePaymentViewController]: Error: Input verification failed.");
            return;
        }
        
        //TODO: display confirmation message? Are you sure you want to submit.
        
        [self.paymentManager initializePMManager:paymillMode success:^{
            if([self.paymentManager isInitialized])
            {
                /* do payment */
                paymentInProgress = YES;
                self.paymentActivityIndicator.hidden = NO;
                [self.paymentActivityIndicator startAnimating];
                [self.paymentManager performPayment:paymentCardHolder ccn:paymentCardNumber ccExpiryDate:paymentExpiryDate cvc:paymentCardCode eventDateTime:_booking.date
                                            success:^(void){
                                                NSLog(@"[MixtablePaymentViewController]:Payment success!");
                                                self.paymentActivityIndicator.hidden = YES;
                                                [self.paymentActivityIndicator stopAnimating];
                                                
                                                _booking.booked = YES;
                                                MixtableUserDataManager *userDataManager = [MixtableUserDataManager sharedManager];
                                                [userDataManager addUserBooking:_booking];
                                                
                                                [[NSNotificationCenter defaultCenter]
                                                 postNotificationName:@"MixtableRedrawDashNotification"
                                                 object:_booking];
                                                
                                                //Go back to dashboard.
                                                MixtableInvitationViewController* invitaionViewController = [[MixtableInvitationViewController alloc] initWithBooking:_booking];
                                                [self.navigationController pushViewController:invitaionViewController animated:YES];
                                                
                                                paymentInProgress = NO;
                                            }
                                            failure:^(NSString* error){
                                                NSLog(@"[MixtablePaymentViewController]: Payment failure");
                                                self.paymentActivityIndicator.hidden = YES;
                                                [self.paymentActivityIndicator stopAnimating];
                                                [self showMessage:@"Payment failed!" text:@"Check your credentials and internet connection and try again."];
                                                
                                                paymentInProgress = NO;
                                            }];
            }
            
        } failure:^(NSString* error){
            NSLog(@"[MixtablePaymentViewController]: PMManager initialization failure!");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Can not proceed with payment!" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }];
    }
}

-(void)prevPage:(id)sender{
    UINavigationController *navController = self.navigationController;
    [navController popViewControllerAnimated:NO];
}

/**************************************/
#pragma marl - UITableView Data Source
/**************************************/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = [indexPath row];
    static NSString *cellIdentifier = @"";
    switch (row) {
        case 0:
        {
            cellIdentifier = @"MixtablePaymentCardHolderCell";
            MixtablePaymentCardHolderCell *cardHolderCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cardHolderCell == nil){
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MixtablePaymentCardHolderCell" owner:self options:nil];
                cardHolderCell = [nib objectAtIndex:0];
            }
            [cardHolderCell.input addTarget:self action:@selector(setCardHolder:) forControlEvents:UIControlEventEditingDidEnd];
            cardHolderCell.input.delegate = self;
            
            /* avoid clearing value on redraw */
            if(![paymentCardHolder isEqualToString:@""])
                cardHolderCell.input.text = paymentCardHolder;
            
            return cardHolderCell;
        }
        case 1:
        {
            cellIdentifier = @"MixtablePaymentCardNumberCell";
            MixtablePaymentCardNumberCell *cardNumberCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cardNumberCell == nil){
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MixtablePaymentCardNumberCell" owner:self options:nil];
                cardNumberCell = [nib objectAtIndex:0];
            }
            [cardNumberCell.input addTarget:self action:@selector(setCardNumber:) forControlEvents:UIControlEventEditingDidEnd];
            cardNumberCell.input.delegate = self;
            
            /* avoid clearing value on redraw */
            if(![paymentCardNumber isEqualToString:@""])
                cardNumberCell.input.text = paymentCardNumber;
            
            return cardNumberCell;
        }
        case 2:
        {
            cellIdentifier = @"MixtablePaymentExpireDateCell";
            MixtablePaymentExpireDateCell *expireDateCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (expireDateCell == nil){
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MixtablePaymentExpireDateCell" owner:self options:nil];
                expireDateCell = [nib objectAtIndex:0];
            }
            [expireDateCell.input addTarget:self action:@selector(setExpiryDate:) forControlEvents:UIControlEventEditingDidEnd];
            expireDateCell.input.delegate = self;
            
            /* avoid clearing value on redraw */
            if(![paymentExpiryDate isEqualToString:@""])
                expireDateCell.input.text = paymentExpiryDate;
            
            return expireDateCell;
        }
        case 3:
        {
            cellIdentifier = @"MixtablePaymentCodeCell";
            MixtablePaymentCodeCell *codeCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (codeCell == nil){
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MixtablePaymentCodeCell" owner:self options:nil];
                codeCell = [nib objectAtIndex:0];
            }
            [codeCell.input addTarget:self action:@selector(setCode:) forControlEvents:UIControlEventEditingDidEnd];
            codeCell.input.delegate = self;
            
            /* avoid clearing value on redraw */
            if(![paymentCardCode isEqualToString:@""])
                codeCell.input.text = paymentCardCode;
            
            return codeCell;
        }
        default:
            break;
    }
    
    UITableViewCell * cell = [[UITableViewCell alloc] init];
	return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self resignFirstResponder];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 74.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    [view setBackgroundColor:[UIColor clearColor]];
    [view setAlpha:0.4F];
    /*UIButton *doneBtn = [[UIButton alloc]initWithFrame:CGRectMake(250, 0, 70,50)];
     [doneBtn addTarget:self action:@selector(hideKeyboard:) forControlEvents:UIControlEventAllEvents];
     [doneBtn setTitle:@"Done" forState:UIControlStateNormal];
     [doneBtn setBackgroundColor:[UIColor blackColor]];
     [view addSubview:doneBtn];*/
    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320,25)];
    [header setText:@" Enter Card Information"];
    [header setTextColor:[UIColor whiteColor]];
    [header setBackgroundColor:[UIColor blackColor]];
    [view addSubview:header];
    return view;
}
/**************************************/
#pragma mark - TextFields actions
/**************************************/
-(void) setCardHolder:(UITextField*)textField
{
    NSLog(@"[MixtablePaymentViewController]: Entered Card holder: %@", textField.text);
    paymentCardHolder = textField.text;
}
-(void) setCardNumber:(UITextField*)textField
{
    NSLog(@"[MixtablePaymentViewController]: Entered Card Number: %@", textField.text);
    paymentCardNumber = textField.text;
}
-(void) setExpiryDate:(UITextField*)textField
{
    NSLog(@"[MixtablePaymentViewController]: Entered Expiry Date: %@", textField.text);
    paymentExpiryDate = textField.text;
}
-(void) setCode:(UITextField*)textField
{
    NSLog(@"[MixtablePaymentViewController]: Entered Card Code: %@", textField.text);
    paymentCardCode = textField.text;
}

/**************************************/
#pragma mark - UITextFieldDelegate
/**************************************/
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.tap.enabled = YES;
    editedField = textField;
}

/* hide keyboard on tap outside of textfield*/
-(void)hideKeyboard
{
    [editedField resignFirstResponder];
    self.tap.enabled = NO;
}

/**************************************/
#pragma mark - UI validation methods
/**************************************/
- (bool)inputVerification
{
    BOOL paymentShouldOccur = YES|NO;
    NSString *msg = @"Please enter:";
    
    if([paymentCardNumber isEqualToString:@""])
    {
        msg = [msg stringByAppendingString: @" credit card number,"];
        paymentShouldOccur = NO;
    }
    else {
        PMCreditCardCheck *recognizedCC = [[PMCreditCardTypeParser instance] checkExpression:paymentCardNumber];
        if(recognizedCC.result == INVALID) {
            msg = [msg stringByAppendingString:@" supported credit card type,"];
            paymentShouldOccur = NO;
        }
        else  if( [self luhnCheck:paymentCardNumber] == 0) // && != @"0"
        {
            msg = [msg stringByAppendingString:@" correct credit card number,"];
            paymentShouldOccur = NO;
        }
    }
    if([paymentCardCode isEqualToString:@""])
    {
        msg = [msg stringByAppendingString: @" CVC,"];
        paymentShouldOccur = NO;
    }
    
    if([paymentCardHolder isEqualToString:@""])
    {
        msg = [msg stringByAppendingString:@" name,"];
        paymentShouldOccur = NO;
    }
    
    // date lenght is 7 as it has to be in format MM/YYYYY
    BOOL vaildDateFormat = ![paymentExpiryDate isEqualToString:@""] && (paymentExpiryDate.length == 7);
    NSString* expMonthStr = vaildDateFormat ? [paymentExpiryDate substringWithRange:NSMakeRange(0,2)] : @"";
    NSString* expYearStr = vaildDateFormat ? [paymentExpiryDate substringWithRange:NSMakeRange(3,4)] : @"";
    if([expMonthStr isEqualToString:@""] || [expYearStr isEqualToString:@""] ||
       !expMonthStr || !expYearStr)
    {
        msg = [msg stringByAppendingString:@" expiration date"];
        paymentShouldOccur = NO;
        
    }
    
    NSDate *date = [NSDate date];
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit;
    
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:date];
    NSInteger year = [dateComponents year];
    NSInteger month = [dateComponents month];
    
    if (expMonthStr.length > 2 || expYearStr.length > 4)
    {
        paymentShouldOccur = NO;
        msg = @"Incorrect expiration date!";
    }
    
    //NSString *expYear2000Str = [NSString stringWithFormat:@"20%@", expYearStr];
    
    //Verification for expiration date of the credit card
    if(![expYearStr isEqualToString:@""] && ![expMonthStr isEqualToString:@""] && (expYearStr.intValue < year ||
                                                                                   (expYearStr.intValue == year && expMonthStr.intValue < month)))
    {
        paymentShouldOccur = NO;
        msg = NSLocalizedString(@"The credit card has expired!", @"The credit card has expired!");
    }
	
    if (!paymentShouldOccur)
    {
        msg = [msg stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
        msg = [msg stringByAppendingString:@"!"];
        
        [self showMessage:@"Alert" text:msg];
    }
	
    return paymentShouldOccur;
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
-(BOOL)luhnCheck:(NSString*)stringToTest
{
	BOOL isOdd = YES;
	int oddSum = 0;
	int evenSum = 0;
    
	for (int i = [stringToTest length] - 1; i >= 0; i--)
    {
        NSRange r = {i, 1};
        int digit = [[stringToTest substringWithRange:r] intValue];
		
		if (isOdd)
			oddSum += digit;
		else
			evenSum += digit/5 + (2*digit) % 10;
        
		isOdd = !isOdd;
	}
    
	return ((oddSum + evenSum) % 10 == 0);
}

//###############################
# pragma ui adjustment
//###############################
- (void)adjustUIForDisplay
{
    
    CGFloat maxHeight = [[UIScreen mainScreen]bounds].size.height - self.paymentTableView.frame.size.height - self.navigationController.navigationBar.frame.size.height;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.footerViewHeightConstraint.constant = maxHeight;
        [self.view needsUpdateConstraints];
    }];
    
}
@end
