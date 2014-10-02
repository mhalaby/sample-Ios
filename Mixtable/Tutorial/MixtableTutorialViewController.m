//
//  MixtableTutorialViewController.m
//  Mixtable
//
//  Created by Wessam Abdrabo on 12/15/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import "MixtableTutorialViewController.h"

@interface MixtableTutorialViewController ()

@end

@implementation MixtableTutorialViewController

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
    [self setView:self.initialView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) loadTutorialView
{
    switch (self.index) {
        case 0:{
            [self.view removeFromSuperview];
            [self.view addSubview:self.screen1];
            break;
        }
        case 1:{
            [self.view removeFromSuperview];
            [self.view addSubview:self.screen2];
            break;
        }
        case 2:{
            [self.view removeFromSuperview];
            [self.view addSubview:self.screen3];
            break;
        }
        case 3:{
            [self.view removeFromSuperview];
            [self.view addSubview:self.screen4];
            break;
        }
        case 4:{
            [self.view removeFromSuperview];
            [self.view addSubview:self.screen5];
            break;
        }
            
        default:
            break;
    }
    [self.view setNeedsDisplay];
}
@end
