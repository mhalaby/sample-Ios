//
//  MixtableBookingCancellationViewController.m
//  Mixtable
//
//  Created by Wessam Abdrabo on 4/21/14.
//  Copyright (c) 2014 Mixtable. All rights reserved.
//

#import "MixtableBookingCancellationViewController.h"

@interface MixtableBookingCancellationViewController ()

@end

@implementation MixtableBookingCancellationViewController

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
    [super viewDidLoad];
    self.navigationItem.title = @"Cancellation";
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"  style:UIBarButtonItemStyleBordered target:self action:@selector(prevPage:)];
    self.navigationItem.leftBarButtonItem = backBtnItem;
}
-(void)prevPage:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
