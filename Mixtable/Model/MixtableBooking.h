//
//  MixtableBooking.h
//  Mixtable
//
//  Created by Muhammad on 25/11/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MixtableCity.h"

@interface MixtableBooking : NSObject
@property(strong, nonatomic) NSDate* date;
@property(strong, nonatomic) NSString* time;
@property(assign, nonatomic) BOOL booked;
@property(strong, nonatomic) MixtableCity *city;
@end
