//
//  MixtablePersonalSettingsViewController.m
//  Mixtable
//
//  Created by Wessam Abdrabo on 11/30/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import "MixtablePersonalSettingsViewController.h"
#import "MixtableMixingSettingsViewController.h"
#import "MixtableCustomPickerControlCell.h"
#import "MixtableSegementedControlCell.h"
#import "MixtablePickerControlCell.h"
#import "MixtableMultiSegementedControlCell.h"

@implementation MixtablePersonalSettingsViewController

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
    
    [super viewDidLoad:self.preferencesTableView footer:self.footer setSelectedSegment:1];
    
    [self.preferencesTableView registerClass:[MixtableCustomPickerControlCell class] forCellReuseIdentifier:@"MixtableCustomPickerControlCell"];
    [self.preferencesTableView
     registerClass:[MixtableSegementedControlCell class] forCellReuseIdentifier:@"MixtableSegementedControlCell"];
    [self.preferencesTableView
     registerClass:[MixtablePickerControlCell class] forCellReuseIdentifier:@"MixtablePickerControlCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)nextPage:(id)sender{
    UINavigationController *navController = self.navigationController;
    MixtableMixingSettingsViewController *mixingViewController = [[MixtableMixingSettingsViewController alloc] init];
    [super save:super.userDataManager.user];
    [navController pushViewController:mixingViewController animated:NO];
}

-(void)prevPage:(id)sender{
    UINavigationController *navController = self.navigationController;
    [navController popViewControllerAnimated:NO];
}

#pragma marl - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier;
    NSArray* fields  = [NSArray arrayWithObjects:@"Sex",@"Height",@"What have you done?",@"What are you doing?",@"Relgious Role for Mixtable?",nil];

    if ([indexPath row] == 1) {
        cellIdentifier = @"MixtableCustomPickerControlCell";
        MixtableCustomPickerControlCell* cell = [[MixtableCustomPickerControlCell alloc]init];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        cell._items=[self generateHeight];
        [cell.picker reloadData];
        if (cell == nil){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MixtableCustomPickerControlCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        [cell.cellTitle setText:[fields objectAtIndex:[indexPath row]]];
        cell._tag=@"height";
        return cell;
    }
    else if ([indexPath row] == 4) {
        cellIdentifier = @"MixtablePickerControlCell";
        MixtablePickerControlCell* cell = [[MixtablePickerControlCell alloc]init];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MixtablePickerControlCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell._items = [NSMutableArray arrayWithObjects:@"No role",@"Big role, my religion is None",@"Big role, my religion is Catholicism",@"Big role, my religion is Ebangelicalism",@"Big role, my religion is Hinduism",@"Big role, my religion is Buddhism",@"Big role, my religion is Islam",@"Big role, my religion is Judaism",@"Big role, my religion is Other",nil];
        [cell.cellTitle setText:[fields objectAtIndex:[indexPath row]]];
        cell._tag=@"religion";
        return cell;
    } else {
        cellIdentifier = @"MixtableSegementedControlCell";
        
        MixtableSegementedControlCell* cell = [[MixtableSegementedControlCell alloc] init];
        
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
                cell._tag = @"gender";
                cell._items=[NSArray arrayWithObjects:@"Male",@"Female", nil ];
                break;
            case 2:
                [multiSelectedCell.cellTitle setText:[fields objectAtIndex:[indexPath row]]];
             
                multiSelectedCell._items = [NSArray arrayWithObjects:@"A-levels",@"apprentiship",@"university",nil];
                multiSelectedCell._tag = @"education";
                return multiSelectedCell;
            case 3:
               
                cell._tag = @"occupations";
                cell._items=[NSArray arrayWithObjects:@"Employed",@"Student", nil ];
                break;

        }
        return cell;
    }
}

-(NSMutableArray*)generateHeight{
    NSMutableArray* values = [[NSMutableArray alloc] initWithCapacity:100];
    for (int i = 150; i <= 210; i++)
    {
        NSNumber *num = [NSNumber numberWithInt:i];
        NSString *numStr = [NSString stringWithFormat:@"%@",num];
        [values addObject:numStr];
    }
    return values;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0 && indexPath.row == 1) {
        return 44;
    } else if ( indexPath.row == 4) {
        return 130;
    }
    return 68;
}



@end
