//
//  MixtableTutorialPageViewController.m
//  Mixtable
//
//  Created by Wessam Abdrabo on 12/15/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import "MixtableTutorialPageViewController.h"
#import "MixtableTutorialViewController.h"

@interface MixtableTutorialPageViewController ()

@end

@implementation MixtableTutorialPageViewController

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
    /* back button */
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"  style:UIBarButtonItemStyleBordered target:self action:@selector(prevPage:)];
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = backBtnItem;
    
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageController.dataSource = self;
    
    CGFloat screenHeight = [[UIScreen mainScreen]bounds].size.height;
    CGFloat pcHeight = screenHeight == 480 ?  510 : 480;
    CGRect rect = CGRectMake(0, 10, 320, pcHeight);
    [[self.pageController view] setFrame:rect];
    //[[self.pageController view] setFrame:[[self view] bounds]];
    
    MixtableTutorialViewController *initialViewController = [self viewControllerAtIndex:0];
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)prevPage:(id)sender
{
    UINavigationController *navController = self.navigationController;
    [navController popViewControllerAnimated:YES];
}
//###############################
# pragma page view contoller methods
//###############################

- (MixtableTutorialViewController *)viewControllerAtIndex:(NSUInteger)index {
    MixtableTutorialViewController *childViewController = [[MixtableTutorialViewController alloc] initWithNibName:@"MixtableTutorialViewController" bundle:nil];
    childViewController.index = index;
    [childViewController loadTutorialView];
    return childViewController;
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [(MixtableTutorialViewController *)viewController index];
    if (index == 0) {
        return nil;
    }
    
    // Decrease the index by 1 to return
    index--;
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(MixtableTutorialViewController *)viewController index];
    index++;
    
    if (index == 5) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
    
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return 5;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}
@end
