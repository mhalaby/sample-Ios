//
//  MixtableAPIClient.m
//  Mixtable
//
//  Created by Wessam Abdrabo on 11/16/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import "MixtableAPIClient.h"
#import "MixtableAPIClientDelegate.h"
#import "MixtableConfigManager.h"
@implementation MixtableAPIClient

NSString* appURL;
-(id)init{
    appURL =[[MixtableConfigManager sharedInstance] getAPIUrl];
    return self;
}
-(void)fetchUsersUsingAPI {
    NSString *urlAsString = [NSString stringWithFormat:@"%@/users",appURL];
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    NSLog(@"%@", urlAsString);
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            [self.delegate fetchingUsersFailedWithError:error];
        } else {
            [self.delegate receivedUsersJSON:data];
        }
    }];
}

-(void)fetchUserByEmailUsingAPI:(NSString*)email {
    NSString *urlAsString = [NSString stringWithFormat:@"%@/users/%@",appURL,[email stringByReplacingOccurrencesOfString:@"." withString:@"%2F"]];
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    NSLog(@"%@", urlAsString);
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            [self.delegate fetchingUsersFailedWithError:error];
        } else {
            [self.delegate receivedUserJSON:data];
        }
    }];
}


-(void)createUserUsingAPI:(NSData*)jsonData{
    NSString *urlAsString = [NSString stringWithFormat:@"%@/users",appURL];
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:jsonData];
    NSLog(@"POST request %@", request);

    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {

        if (error) {
             NSLog(@"POST ERROR %@", error);
            [self.delegate creatingUserFailedUsingAPI:error];
        }
    }];
}

-(void)updateUserUsingAPI:(NSData*)jsonData email:(NSString*)email{
    NSString *urlAsString = [NSString stringWithFormat:@"%@/users/%@",appURL,[email stringByReplacingOccurrencesOfString:@"." withString:@"%2F"]];
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"PUT"];
    [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:jsonData];
    NSLog(@"PUT request %@", request);
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            NSLog(@"PUT ERROR %@", error);
            [self.delegate updatingUserFailedUsingAPI:error];
        }
    }];
}
-(void)sendInvitation:(NSData*)jsonData {
    NSString *urlAsString = [NSString stringWithFormat:@"%@/invitations",appURL];
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:jsonData];
    NSLog(@"POST request %@", request);
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            NSLog(@"POST ERROR %@", error);
            [self.delegate sendingInvitationFailedUsingAPI:error];
        }
    }];
}

-(void)createPaymentUsingAPI:(NSData*)jsonData{
    NSString *urlAsString = [NSString stringWithFormat:@"%@/payments",appURL];
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:jsonData];
    NSLog(@"POST request %@", request);
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            NSLog(@"POST ERROR %@", error);
            [self.delegate creatingPaymentFailedUsingAPI:error];
        }
    }];
}

-(void)fetchBookingsUsingAPI {
    NSString *urlAsString = [NSString stringWithFormat:@"%@/mixtable_bookings",appURL];
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    NSLog(@"%@", urlAsString);
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            [self.delegate fetchingBookingsFailedWithError:error];
        } else {
            [self.delegate receivedBookingsJSON:data];
        }
    }];
}

@end
