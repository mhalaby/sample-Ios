//
//  MixtableEventsFactory.h
//  Mixtable
//
//  Created by Wessam Abdrabo on 12/21/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MixtableEventsFactory : NSObject
+ (id) sharedInstance;
- (void) createComingEvents;
- (NSDate*) getNextWednesday;
- (NSDate*) getNextThursday;
- (NSDate*) getFollowingWednesday;
- (NSDate*) getFollowingThursday;
- (NSString*) getEventsTime;
@end
