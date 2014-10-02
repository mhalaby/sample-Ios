//
//  MixtableContactsViewController.h
//  Mixtable
//
//  Created by Wessam Abdrabo on 11/17/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MixtableContactsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *callView;
@property (weak, nonatomic) IBOutlet UIView *emailView;
- (IBAction)callUsActionBtn:(id)sender;
- (IBAction)emailActionBtn:(id)sender;
- (IBAction)fbActionBtn:(id)sender;
- (IBAction)twitterActionBtn:(id)sender;

@end
