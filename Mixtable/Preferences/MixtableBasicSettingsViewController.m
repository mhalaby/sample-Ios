//
//  MixtableBasicSettingsViewController.m
//  Mixtable
//
//  Created by Muhammad El-Halaby on 11/30/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import "MixtableBasicSettingsViewController.h"
#import "MixtablePersonalSettingsViewController.h"
#import "MixtableSwipeNavViewController.h"
#import "SWRevealViewController.h"
#import "MixtableAppDelegate.h"
#import "MixtableBasicPreferencesCell.h"
#import "MixtableBasePrefrencesViewController.h"
#import "MixtableFBLoginManager.h"
#import "MixtableUserDataManager.h"
#import "MixtablePickerControlCell.h"
#import "MixtableCityDataManager.h"

@interface MixtableBasicSettingsViewController ()
    @property MixtableCityDataManager* cityManager;
@end

@implementation MixtableBasicSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad:self.basicTableView footer:self.footer setSelectedSegment:0];
    [self.basicTableView registerClass:[MixtableBasicPreferencesCell class] forCellReuseIdentifier:@"MixtableBasicPreferencesCell"];
    [self.basicTableView
     registerClass:[MixtablePickerControlCell class] forCellReuseIdentifier:@"MixtablePickerControlCell"];
    //tap gesture recognizer
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    self.tap.enabled = NO;
    [self.view addGestureRecognizer:self.tap];
    _fields  = [NSArray arrayWithObjects:@"First Name",@"Last Name",@"Email",@"City",nil];
    _values  = [NSArray arrayWithObjects:[super.userDataManager getFirstName],[super.userDataManager getLastName],[super.userDataManager getEmail],[super.userDataManager getCity],nil];
    _tags  = [NSArray arrayWithObjects:@"first_name",@"last_name",@"email",@"city",nil];

    _cityManager = [MixtableCityDataManager sharedInstance];

    //save old email to check later if it changed
    [super setOldEmail:[super.userDataManager getEmail]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)nextPage:(id)sender{
    if([super validate]){
        UINavigationController *navController = self.navigationController;
        MixtablePersonalSettingsViewController *personalViewController = [[MixtablePersonalSettingsViewController alloc] init];
        [super save:super.userDataManager.user];
        [navController pushViewController:personalViewController animated:NO];
    }
}

-(void)prevPage:(id)sender{
    if([super validate]){
        [super save:super.userDataManager.user];
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"MixtableRedrawCityNotification"
         object:self
         ];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma marl - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([indexPath row] ==3){
        MixtablePickerControlCell* pickerCell = [[MixtablePickerControlCell alloc]init];
        pickerCell = [tableView dequeueReusableCellWithIdentifier:@"MixtablePickerControlCell"];
        //customization for this cell!
        [pickerCell.cellTitle setText:[_fields objectAtIndex:[indexPath row]]];
        pickerCell._tag = [_tags objectAtIndex:[indexPath row]];
        pickerCell.cellTitle.frame = CGRectMake(tableView.frame.size.width/2 -80, 18, 40,30);
        pickerCell.picker.frame = CGRectMake(tableView.frame.size.width/2 -60,-50,100,1);
        pickerCell.scrollView.frame = CGRectMake(20 ,3,200,70);
        if (pickerCell == nil){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MixtablePickerControlCell" owner:self options:nil];
            pickerCell = [nib objectAtIndex:0];
        }
        pickerCell._items = [[_cityManager getAllCities] valueForKey:@"name"];
        return pickerCell;

    }
    MixtableBasicPreferencesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MixtableBasicPreferencesCell"];
    if (cell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MixtableBasicPreferencesCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell._tag = [_tags objectAtIndex:[indexPath row]];
    [cell.cellTitle setText:[_fields objectAtIndex:[indexPath row]]];
    [cell.cellInput setPlaceholder:[_fields objectAtIndex:[indexPath row]]];
    if(_values  && [_values count])
        [cell.cellInput setText:[_values objectAtIndex:[indexPath row]]];
    [cell.cellInput setText:[_values objectAtIndex:[indexPath row]]];
    cell.cellInput.delegate = self;
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /* dismiss keyboard. Needed otherwise the last edited field value won't be reached */
    [self.editedField resignFirstResponder];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0 && indexPath.row == 3) {
        return 80;
    }
    return 40;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        //delete it
    }
}

/**************************************/
#pragma mark - UITextFieldDelegate
/**************************************/

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.tap.enabled = YES;
    self.editedField = textField;
}

/* hide keyboard on tap outside of textfield*/
-(void)hideKeyboard
{
    [self.editedField resignFirstResponder];
    self.tap.enabled = NO;
}

@end
