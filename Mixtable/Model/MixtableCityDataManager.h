//
//  MixtableCityDataManager.h
//  Mixtable
//
//  Created by Muhammad on 12/04/14.
//  Copyright (c) 2014 Mixtable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MixtableCity.h"

#define CITY_STATUS_RUNNING @"running"
#define CITY_STATUS_ACTIVE @"active"
#define CITY_STATUS_INACTIVE @"inactive"
#define CITY_STATUS_ACTIVE_MSG @"Excited? We are now considering your application. If everything fits, you can get on and book your first Mixtable."
#define CITY_STATUS_INACTIVE_MSG @"Your city is not yet active. We'll tell you when we are there."

@interface MixtableCityDataManager : NSObject
+ (id) sharedInstance;
-(NSMutableArray*)getAllCities;
-(MixtableCity*)createCityFromName:(NSString*)cityName;
-(NSString*) getCityStatusFromCityName:(NSString*)cityName;
@end
