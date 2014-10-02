//
//  MixtableMixingSettingsViewController.m
//  Mixtable
//
//  Created by Wessam Abdrabo on 11/30/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import "MixtableMixingSettingsViewController.h"
#import "MixtableAppDelegate.h"
#import "MixtableSliderCell.h"
#import "MixtableSegementedControlCell.h"
#import "MixtableMultiSegementedControlCell.h"
@interface MixtableMixingSettingsViewController ()

@end

@implementation MixtableMixingSettingsViewController

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
    /* Customization for navigation items. Shouldn't be here!! */
   
    [super viewDidLoad:self.settingsTableView footer:self.footer setSelectedSegment:2];

    
    [self.settingsTableView registerClass:[MixtableSliderCell class] forCellReuseIdentifier:@"MixtableSliderCell"];
    [self.settingsTableView registerClass:[MixtableSegementedControlCell class] forCellReuseIdentifier:@"MixtableSegementedControlCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prevPage:(id)sender{
    UINavigationController *navController = self.navigationController;
    [navController popViewControllerAnimated:NO];
    [super save:super.userDataManager.user];
}

-(void)done:(id)sender{
    //TODO: user creation action
    UINavigationController *navController = self.navigationController;
    [navController popToRootViewControllerAnimated:NO];
    [super save:super.userDataManager.user];
    super.userDataManager.user.firstTime = NO;
}
#pragma marl - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 5;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return 2;
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier;
    NSArray* fields  = [NSArray arrayWithObjects:@"Who Would You like to meet? ",@"What Language should your mixtable be in?",nil];
    if([indexPath section] == 0) {
        if ([indexPath row] == 0 || [indexPath row] == 1 ) {
            cellIdentifier = @"MixtableSegementedControlCell";

            MixtableSegementedControlCell* cell = [[MixtableSegementedControlCell alloc]init];
            MixtableMultiSegementedControlCell* multiSelectedCell = [[MixtableMultiSegementedControlCell alloc]init];

            if (cell == nil){
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MixtableSegementedControlCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            [cell.cellTitle setText:[fields objectAtIndex:[indexPath row]]];
            switch (indexPath.row)
            {
                case 0:
                    cell._tag = @"preferred_genders";
                    cell._items= [NSArray arrayWithObjects:@"3 Girls",@"3 Guys",nil];
                    break;
                case 1:
                    [multiSelectedCell.cellTitle setText:[fields objectAtIndex:[indexPath row]]];
                    multiSelectedCell._tag = @"preferred_languages";
                    multiSelectedCell._items= [NSArray arrayWithObjects:@"German",@"English",nil];
                    return multiSelectedCell;
            }
            return cell;
        }
    }

        cellIdentifier = @"MixtableSliderCell";
        MixtableSliderCell* cell = [[MixtableSliderCell alloc]init];
        if (cell == nil){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MixtableSliderCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        [cell.cellTitle setTextAlignment:NSTextAlignmentLeft];
    if([indexPath section] == 1)
        {
            [cell.cellTitle setText:@"What age should your other mixers be?"];
            [cell.slider setMinimumValueImage:[UIImage imageNamed:@"Pref_Ipad.png"]];
            [cell.slider setMaximumValueImage:[UIImage imageNamed:@"Pref_Fernseher_new.png"]];
            [cell.minTitle setText:@"Younger"];
            [cell.maxTitle setText:@"Older"];
            cell._tag = @"target_age";

            return cell;
        }
        if([indexPath section] == 2)
        {
            [cell.cellTitle setText:@"What kind of bar would you like?"];
            [cell.slider setMinimumValueImage:[UIImage imageNamed:@"Pref_Beer.png"]];
            [cell.slider setMaximumValueImage:[UIImage imageNamed:@"Pref_Martini.png"]];
            [cell.minTitle setText:@"  Pub"];
            [cell.maxTitle setText:@"Fancy Bar"];
            cell._tag = @"target_venue";
            return cell;
        }
        if([indexPath section] == 3)
        {
            [cell.cellTitle setText:@"What would you like to talk about?"];
            [cell.slider setMinimumValueImage:[UIImage imageNamed:@"Pref_Fussi.png"]];
            [cell.slider setMaximumValueImage:[UIImage imageNamed:@"Pref_Graduate.png"]];
            [cell.minTitle setText:@"Big Brother"];
            [cell.maxTitle setText:@"Philosophy"];
            cell._tag = @"target_conversation";
            return cell;
        }
        if([indexPath section] == 4)
        {
            [cell.cellTitle setText:@"What do you expect?"];
            [cell.slider setMinimumValueImage:[UIImage imageNamed:@"Pref_Bomb.png"]];
            [cell.slider setMaximumValueImage:[UIImage imageNamed:@"Pref_Heart.png"]];
            [cell.minTitle setText:@"Anything is Possible"];
            [cell.maxTitle setText:@"Something Serious"];
            cell._tag=@"target_expectation";
            return cell;
        }
        return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        return 68.0;
    }
    return 80;
}
@end
