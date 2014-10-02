//
//  MixtableContactsViewController.m
//  Mixtable
//
//  Created by Wessam Abdrabo on 11/17/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import "MixtableContactsViewController.h"
#import "MixtableConfigManager.h"

@interface MixtableContactsViewController ()
@property (strong, nonatomic) NSString *contactNumber;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *fbPageID;
@property (strong, nonatomic) NSString *twitterPageURL;
@end

@implementation MixtableContactsViewController

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
    MixtableConfigManager* configManager = [MixtableConfigManager sharedInstance];
    
    self.contactNumber = [configManager getContactNumber];
    self.email = [configManager getContactEmail];
    self.fbPageID = [configManager getFBPageID];
    self.twitterPageURL = [configManager getTwitterPageURL];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)callUsActionBtn:(id)sender {
    NSURL* callUrl=[NSURL URLWithString:[NSString   stringWithFormat:@"tel:%@",self.contactNumber]];
        if([[UIApplication sharedApplication] canOpenURL:callUrl]) {
        [[UIApplication sharedApplication] openURL:callUrl];
    } else {
        NSLog(@"Error making call");
    }
}

- (IBAction)emailActionBtn:(id)sender {
    NSURL* emailUrl=[NSURL URLWithString:[NSString   stringWithFormat:@"mailto:%@",self.email]];
    if([[UIApplication sharedApplication] canOpenURL:emailUrl]) {
        [[UIApplication sharedApplication] openURL:emailUrl];
    } else {
        //TODO: Display alert
        NSLog(@"[MixtableContactsViewController]: Error sending email");
    }
}

- (IBAction)fbActionBtn:(id)sender {
    NSURL* fbUrl=[NSURL URLWithString:[NSString  stringWithFormat:@"fb://page/%@",self.fbPageID]];
    if([[UIApplication sharedApplication] canOpenURL:fbUrl]) {
        [[UIApplication sharedApplication] openURL:fbUrl];
    } else {
        //TODO: Display alert
        NSLog(@"[MixtableContactsViewController]: Error opening fb page");
    }
}

- (IBAction)twitterActionBtn:(id)sender {
    NSURL* twitterURL=[NSURL URLWithString:[NSString  stringWithFormat:@"%@",self.twitterPageURL]];
    if([[UIApplication sharedApplication] canOpenURL:twitterURL]) {
        [[UIApplication sharedApplication] openURL:twitterURL];
    } else {
        //TODO: Display alert
        NSLog(@"[MixtableContactsViewController]: Error opening twitter page");
    }}
@end
