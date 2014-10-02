//
//  MixtableMixPixViewController.m
//  Mixtable
//
//  Created by Wessam Abdrabo on 3/16/14.
//  Copyright (c) 2014 Mixtable. All rights reserved.
//

#import "MixtableMixPixViewController.h"
#import "MixtableConfigManager.h"

@interface MixtableMixPixViewController ()

@end

@implementation MixtableMixPixViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.webView.delegate = self;
    
    MixtableConfigManager *configManager = [MixtableConfigManager sharedInstance];
    NSString *fullURL = [configManager getMixpicsPageURL]; 
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
    
    /* back button */
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"  style:UIBarButtonItemStyleBordered target:self action:@selector(prevPage:)];
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = backBtnItem;
    self.navigationItem.title = @"Mixpics";
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

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

//################################################
#pragma webviewdelegate functions
//################################################
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    // starting the load, show the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // finished loading, hide the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    // load error, hide the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    /*if ([error code] != NSURLErrorCancelled) {
        // report the error inside the webview
        NSString* errorString = [NSString stringWithFormat:
                                 @"<html><center><font size=+5 color='red'>An error occurred:<br>%@</font></center></html>",
                                 error.localizedDescription];
        [self.webView loadHTMLString:errorString baseURL:nil];
    }*/
}

@end
