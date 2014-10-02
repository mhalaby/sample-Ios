//
//  MixtableTutorialViewController.h
//  Mixtable
//
//  Created by Wessam Abdrabo on 12/15/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MixtableTutorialViewController : UIViewController
@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) IBOutlet UIView *screen1;
@property (strong, nonatomic) IBOutlet UIView *screen2;
@property (strong, nonatomic) IBOutlet UIView *screen3;
@property (strong, nonatomic) IBOutlet UIView *screen4;
@property (strong, nonatomic) IBOutlet UIView *screen5;
@property (strong, nonatomic) IBOutlet UIView *initialView;
-(void) loadTutorialView;
@end
