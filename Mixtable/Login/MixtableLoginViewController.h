//
//  MixtableLoginViewController.h
//  Mixtable
//
//  Created by Wessam Abdrabo on 11/11/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MixtableLoginViewController : UIViewController <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageController;
@property (strong, nonatomic) IBOutlet UIView *overlayView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *landingBgImageView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (strong, nonatomic) IBOutlet UIView *loginView;

- (IBAction)doLogin:(id)sender;
- (void)loginFailed;
- (IBAction)continueLogin:(id)sender;
- (IBAction)cancelLogin:(id)sender;

@end
