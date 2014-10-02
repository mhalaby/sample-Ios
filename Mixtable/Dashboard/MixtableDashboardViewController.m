//
//  MixtableDashboardViewController.m
//  Mixtable
//
//  Created by Wessam Abdrabo on 11/13/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import "MixtableDashboardViewController.h"
#import "MixtableEventsTableCell.h"
#import "MixtableUserDataManager.h"
#import "MixtablePaymentDataManager.h"
#import "MixtableAPIClient.h"
#import "MixtableNSDateHelper.h"
#import "MixtableAppDelegate.h"
#import "MixtableBookingDetailsViewController.h"
#import "MixtableEventsFactory.h"
#import "MixtableCityViewController.h"
#import "MixtableCityDataManager.h"

@interface MixtableDashboardViewController (){
    NSMutableArray *events;
    MixtableEventsFactory * eventsFactory;
    NSString* currentCity;
}
@end

@implementation MixtableDashboardViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    /* set city */
    UIFont *cityLabelFont = [UIFont fontWithName:@"Nunito-Regular" size:25];
    self.cityLabel.font = cityLabelFont;
    [self setCityLabel];
    
    /* register for redraw notification. Used when coming back from payment to redraw booked cell. */
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(redraw:)
     name:@"MixtableRedrawDashNotification"
     object:nil];
    
    /*notifcation for redrawing city*/
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(redrawCityLabel:)
     name:@"MixtableRedrawCityNotification"
     object:nil];
    
    /*notifcation for redrawing city*/
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(refreshEvents:)
     name:@"MixtableRefreshEventsNotification"
     object:nil];
    
    /* load user bookings
     */
    MixtableUserDataManager *userDataManager = [MixtableUserDataManager sharedManager];
    [userDataManager loadUserBookingsFromPlist];
    
    //populate events list using events factory
    events = [[NSMutableArray alloc] init];
    eventsFactory = [MixtableEventsFactory sharedInstance];
    [self populateEventsList];
    
    [self drawTableBoundingRectangle];
    
    [self adjustUIForDisplay];
    
    
    [NSTimer scheduledTimerWithTimeInterval:2.0
                                     target:self
                                   selector:@selector(watchNotifications:)
                                   userInfo:nil
                                    repeats:YES];
}

/* reload events in case today's date is later than first event's date*/
-(void) refreshEvents:(NSNotification*)notification{
    if(events && [events count] != 0){
        MixtableBooking * firstBooking = [events objectAtIndex:0];
        if(firstBooking){
            NSDate *today = [NSDate date];
            int daysToAdd = 2;
            NSDate *twoDaysInAdvance = [today dateByAddingTimeInterval:60*60*24*daysToAdd];
            BOOL datesEqual = [MixtableNSDateHelper isSameDay:twoDaysInAdvance otherDay:firstBooking.date];
            if([twoDaysInAdvance compare:firstBooking.date] == NSOrderedDescending && datesEqual == NO){
                [self populateEventsList];
                [self.dashboardTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            }
        }
    }
}

//--THIS WAS ADDED TO SOLVE THE NOTIFICATIONS COMING FROM CALL BACK FUNCTIONs
-(void) watchNotifications: (NSTimer*)timer{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"updateNotificationIcon"
     object:self
     ];
}

/* registered notification to redraw list after coming back  from payment */
-(void) redraw:(NSNotification*)notification
{
    [self updateEventsBookingStatus];
    [self.dashboardTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

// for adding space to the left and right of the table
-(void) drawTableBoundingRectangle{
    CGFloat tableBorderLeft = 4;
    CGFloat tableBorderRight = 4;
    
    CGRect tableRect = /*self.view.frame;*/ self.dashboardTableView.frame;
    tableRect.origin.x += tableBorderLeft; // make the table begin a few pixels right from its origin
    tableRect.size.width -= tableBorderLeft + tableBorderRight; // reduce the width of the table
    self.dashboardTableView.frame = tableRect;
}

- (void)didReceiveMemoryWarning
{    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//######################################################
#pragma city
//######################################################

/*received notification to redraw city after change */
-(void)redrawCityLabel:(NSNotification*)notification{
    [self setCityLabel];
}
/* set city label from plist saved city */
-(void)setCityLabel{
    MixtableUserDataManager *userDataManager = [MixtableUserDataManager sharedManager];
    if(userDataManager){
        NSString * cityFromPlist = [userDataManager getUserCityFromPlist];
        currentCity = [cityFromPlist length] ? cityFromPlist : @"Munich";;
        self.cityLabel.text = currentCity;
    }
    [self adjustCityLabelAndBtnViews];
    [self updateEventsCities]; //update events city and booking status to new city
    [self.dashboardTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}
-(void) adjustCityLabelAndBtnViews{
    [self.cityLabel sizeToFit];
    CGFloat cityArrowX = self.cityLabel.frame.origin.x + self.cityLabel.frame.size.width  + 5;
    [self.cityButton setFrame:CGRectMake(cityArrowX,  self.cityButton.frame.origin.y
                                         , self.cityButton.frame.size.width, self.cityButton.frame.size.height)];
}
- (IBAction)cityBtnAction:(id)sender
{
    MixtableCityViewController * cityViewController = [[MixtableCityViewController alloc] initWithSelectedCity:self.cityLabel.text];
    MixtableAppDelegate *appDelegate = (MixtableAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.frontNavController pushViewController:cityViewController animated:NO];
}
//######################################################


//######################################################
#pragma mark - Populate events list using events factory
//######################################################

-(void) populateEventsList
{
    [eventsFactory createComingEvents];
    
    MixtableCityDataManager *cityDataManager = [MixtableCityDataManager sharedInstance];
    NSString* cityName = currentCity;
    MixtableCity* bookingCity = [cityDataManager createCityFromName:cityName];
    
    /* This week's Wednesday */
    MixtableBooking *booking1 = [[MixtableBooking alloc] init];
    booking1.date = [eventsFactory getNextWednesday];
    booking1.time = [eventsFactory getEventsTime];
    booking1.city = bookingCity;
    booking1.booked = [self isEventBooked:booking1] == YES ? YES : NO;
    
    /* This week's Thursday */
    MixtableBooking *booking2 = [[MixtableBooking alloc] init];
    booking2.date = [eventsFactory getNextThursday];
    booking2.time = [eventsFactory getEventsTime];
    booking2.city = bookingCity;
    booking2.booked = [self isEventBooked:booking2] == YES ? YES : NO;
    
    
    /* Next Week's Wednesday */
    MixtableBooking *booking3 = [[MixtableBooking alloc] init];
    booking3.date = [eventsFactory getFollowingWednesday];
    booking3.time = [eventsFactory getEventsTime];
    booking3.city = bookingCity;
    booking3.booked = [self isEventBooked:booking3] == YES ? YES : NO;
    
    
    /* Next Week's Thursday*/
    MixtableBooking *booking4 = [[MixtableBooking alloc] init];
    booking4.date = [eventsFactory getFollowingThursday];
    booking4.time = [eventsFactory getEventsTime];
    booking4.city = bookingCity;
    booking4.booked = [self isEventBooked:booking4] == YES ? YES : NO;
    
    
    if([events count] != 0){
        if([booking1.date compare:booking2.date] == NSOrderedAscending){
            [events setObject:booking1 atIndexedSubscript:0];
            [events setObject:booking2 atIndexedSubscript:1];
        }
        else{
            [events setObject:booking1 atIndexedSubscript:1];
            [events setObject:booking2 atIndexedSubscript:0];
        }
        if([booking3.date compare:booking4.date] == NSOrderedAscending){
            [events setObject:booking3 atIndexedSubscript:2];
            [events setObject:booking4 atIndexedSubscript:3];
        }
        else{
            [events setObject:booking3 atIndexedSubscript:3];
            [events setObject:booking4 atIndexedSubscript:2];
        }
    }else{
        if([booking1.date compare:booking2.date] == NSOrderedAscending){
            [events addObject:booking1];
            [events addObject:booking2];
        }
        else{
            [events addObject:booking2];
            [events addObject:booking1];
        }
        if([booking3.date compare:booking4.date] == NSOrderedAscending){
            [events addObject:booking3];
            [events addObject:booking4];
        }
        else{
            [events addObject:booking4];
            [events addObject:booking3];
        }
    }
}
-(BOOL) isEventBooked:(MixtableBooking*)booking{
    MixtableUserDataManager* userDataManager = [MixtableUserDataManager sharedManager];
    if(userDataManager.user.bookings && [userDataManager.user.bookings  count]){
        for(MixtableBooking* userBooking in userDataManager.user.bookings){
            if(([MixtableNSDateHelper isSameDay:booking.date otherDay:userBooking.date] == YES) &&
               [booking.time isEqualToString:userBooking.time] &&
               [booking.city.name isEqualToString:userBooking.city.name] ){
                return YES;
            }
        }
    }
    return NO;
}

/* needed for when city is changed*/
-(void) updateEventsCities{
    MixtableCityDataManager *cityDataManager = [MixtableCityDataManager sharedInstance];
    NSString* cityName = currentCity;
    MixtableCity* bookingCity = [cityDataManager createCityFromName:cityName];
    
    for(MixtableBooking *booking in events){
        if(booking && booking.city){
            booking.city = bookingCity;
            booking.booked = [self isEventBooked:booking] == YES ? YES : NO;
        }
    }
}
-(void) updateEventsBookingStatus{
    for(MixtableBooking *booking in events){
        if(booking){
            booking.booked = [self isEventBooked:booking] == YES ? YES : NO;
        }
    }
}
//######################################
#pragma mark - Table view data source
//######################################

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    //return 1;
    return events.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //return _bookings.count;
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MixtableEventsTableCell";
    MixtableEventsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MixtableEventsTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    /*Customize the cell. !!Should be removed and put somewhere related to cell*/
    UIFont *timeOfDayLabelFont = [UIFont fontWithName:@"Nunito-Regular" size:60];
    UIFont *weekDayLabelFont = [UIFont fontWithName:@"Nunito-Regular" size:35];
    UIFont *dayLabelFont = [UIFont fontWithName:@"Nunito-Regular" size:50];
    cell.eventTimeOfDayLabel.font = timeOfDayLabelFont;
    cell.eventWeekdayLabel.font = weekDayLabelFont;
    cell.eventDayLabel.font = dayLabelFont;
    cell.eventTimeLabel.font = timeOfDayLabelFont;
    
    
    int index = [indexPath section];
    if(index < events.count){
        MixtableBooking *booking = [events objectAtIndex:index];
        cell.eventDayLabel.text = [MixtableNSDateHelper dayFromNSDate:booking.date];
        cell.eventWeekdayLabel.text = [MixtableNSDateHelper weekdayFromNSDate:booking.date];
        cell.eventTimeLabel.text = [MixtableNSDateHelper time24HrsToTime12Hrs:booking.time];
        cell.eventTimeOfDayLabel.text = [MixtableNSDateHelper timeOfDayFromTime:booking.time];
        
        if(booking.booked){
            [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"grey-box"]]];
        }else{
            [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"orange-box"]]];
        }
        
    }
    else{
        cell.eventDayLabel.text = @"";
        cell.eventTimeLabel.text = @"";
        cell.eventWeekdayLabel.text = @"";
        cell.eventTimeOfDayLabel.text = @"";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSInteger row = [indexPath section];
    MixtableBooking *booking = [events objectAtIndex:row];
    BOOL canDoBooking = [self validateBookingDetails:booking];
    if(canDoBooking){
        MixtableBookingDetailsViewController * bookingDetailsViewController = [[MixtableBookingDetailsViewController alloc] initWithBooking:booking];
        
        /* Navigation to details view controller. Should get the reference to the frontviewcontroller NOT from app delegate!!*/
        MixtableAppDelegate *appDelegate = (MixtableAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.frontNavController pushViewController:bookingDetailsViewController animated:NO];
    }
}

-(BOOL) validateBookingDetails:(MixtableBooking*)booking{
    
    NSString* alertMsg = @"";
    /* Rule 1: booking can not be done twice */
    if(booking.booked == YES){
        //do checking for status if already booked
        alertMsg = @"Mixtable Already Booked!";
    }else{
        /* Rule 2: booking must be 2 days in advance */
        NSDate *today = [NSDate date];
        int daysToAdd = 2;
        NSDate *twoDaysInAdvance = [today dateByAddingTimeInterval:60*60*24*daysToAdd];
        BOOL datesEqual = [MixtableNSDateHelper isSameDay:twoDaysInAdvance otherDay:booking.date];
        if ([twoDaysInAdvance compare:booking.date] == NSOrderedDescending && datesEqual == NO) { /* date1 is later than date2 and not equal*/
            alertMsg = @"Booking Mixtables needs to be 2 days in advance.";
        }
    }
    if([alertMsg length] > 0  )
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
/*Sections headers and footers are used to customize spacing between cells */
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20.0;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    [view setAlpha:0.0F];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(!section)
        return 20.0;
    return 0.0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    [view setAlpha:0.0F];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 107.0;
}


//###############################
# pragma ui adjustment
//###############################
#define FOOTER_VIEW_Y_3_INCH 352
#define FOOTER_VIEW_Y_4_INCH 440

- (void)adjustUIForDisplay
{
    CGFloat screenHeight = [[UIScreen mainScreen]bounds].size.height;
    CGFloat footerViewY = screenHeight == 480 ? FOOTER_VIEW_Y_3_INCH : FOOTER_VIEW_Y_4_INCH;
    
    CGFloat tableViewHeight = screenHeight - self.dashboardTableView.frame.origin.y - self.footerView.frame.size.height -self.navigationController.navigationBar.frame.size.height - 40;
    
    [self adjustCityLabelAndBtnViews];
    
    [self.footerView setFrame:CGRectMake(self.footerView.frame.origin.x,  footerViewY, self.footerView.frame.size.width, self.footerView.frame.size.height)];
    [self.dashboardTableView setFrame:CGRectMake(self.dashboardTableView.frame.origin.x, self.dashboardTableView.frame.origin.y, self.dashboardTableView.frame.size.width, tableViewHeight)];
    [self.cityLabel setFrame:CGRectMake(self.cityLabel.frame.origin.x,  self.cityLabel.frame.origin.y + 5
                                        , self.cityLabel.frame.size.width, self.cityLabel.frame.size.height)];
    [self.view setNeedsDisplay];
    
}

@end
