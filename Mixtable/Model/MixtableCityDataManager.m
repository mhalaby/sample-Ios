//
//  MixtableCityDataManager.m
//  Mixtable
//
//  Created by Muhammad on 12/04/14.
//  Copyright (c) 2014 Mixtable. All rights reserved.
//

#import "MixtableCityDataManager.h"
#import "MixtableUserDataManager.h"

@interface MixtableCityDataManager(){
    NSMutableArray* _runningCities;
    NSMutableArray* _activeCities;
}
@end

@implementation MixtableCityDataManager

+ (id)sharedInstance {
    static MixtableCityDataManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        /* get citites from plist */
        NSMutableArray* cities = [self getAllCities];
        if(cities && [cities count]){
            _runningCities = [[NSMutableArray alloc]init];
            _activeCities = [[NSMutableArray alloc] init];
            for(MixtableCity * city in cities){
                if([city.status isEqualToString:CITY_STATUS_RUNNING])
                   [_runningCities addObject:city.name];
                else if([city.status isEqualToString:CITY_STATUS_ACTIVE])
                    [_activeCities addObject:city.name];
            }
        }else{
            _runningCities = [NSMutableArray arrayWithObjects:@"Munich",@"Berlin",@"Hamburg", nil];
            _activeCities = [NSMutableArray arrayWithObjects:@"Stuttgart",@"Frankfurt",@"Düsseldorf", @"Köln", nil];
        }
    }
    return self;
}

-(MixtableCity*)createCityFromName:(NSString*)cityName{
    MixtableCity *city = [[MixtableCity alloc]init];
    if(city && cityName){
        city.name = cityName;
        city.status = [self getCityStatusFromCityName:cityName];
    }
    return city;
}

-(NSMutableArray*)getAllCities{
    NSString *file = [[NSBundle mainBundle] pathForResource:@"Mixtable-Cities" ofType:@"plist"];
    NSArray *plistDict = [NSArray arrayWithContentsOfFile:file];
    NSMutableArray* cities = [[NSMutableArray alloc] init];
    for(NSDictionary *item in plistDict){
        MixtableCity *city = [[MixtableCity alloc] init];
        city.name = [item valueForKey:@"CityName"];
        city.status = [item valueForKey:@"CityStatus"];
        [cities addObject:city];
    }    
    return cities;
}
-(NSString*) getCityStatusFromCityName:(NSString*)cityName{
    if(cityName && [cityName length]){
        if(_runningCities && [_runningCities count]){
            if([_runningCities containsObject:cityName])
                return CITY_STATUS_RUNNING;
        }
        if(_activeCities && [_activeCities count]){
            if([_activeCities containsObject:cityName])
                return CITY_STATUS_ACTIVE;
        }
        return CITY_STATUS_INACTIVE;
    }
    return nil;
}
@end
