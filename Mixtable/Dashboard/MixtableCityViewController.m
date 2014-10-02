//
//  MixtableCityViewController.m
//  Mixtable
//
//  Created by Wessam Abdrabo on 4/22/14.
//  Copyright (c) 2014 Mixtable. All rights reserved.
//

#import "MixtableCityViewController.h"
#import "MixtableCityDataManager.h"
#import "MixtableCity.h"
#import "MixtableUserDataManager.h"

@interface MixtableCityViewController (){
    NSMutableArray *cities;
    NSString* selectedCity;
    int selectedCityIndex;
}
@end

@implementation MixtableCityViewController

-(id) initWithSelectedCity:(NSString*)city{
    self = [super init];
    
    if(city && [city length]){
        selectedCity = city;
        selectedCityIndex = -1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"City";
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"  style:UIBarButtonItemStyleBordered target:self action:@selector(prevPage:)];
    UIBarButtonItem *doneBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"Done"  style:UIBarButtonItemStyleBordered target:self action:@selector(done:)];
    self.navigationItem.leftBarButtonItem = backBtnItem;
    self.navigationItem.rightBarButtonItem = doneBtnItem;
    [backBtnItem setTintColor:[UIColor whiteColor]];
    [doneBtnItem setTintColor:[UIColor whiteColor]];
    
    if(cities == nil)
        cities = [[NSMutableArray alloc]init];
    
    [self initCities];

    [self.cityPicker selectRow:selectedCityIndex > 0 ? selectedCityIndex : 0 inComponent:0 animated:YES];
}

-(void)prevPage:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)done:(id)sender{
    //save city
    MixtableUserDataManager *userDataManager = [MixtableUserDataManager sharedManager];
    if(userDataManager && selectedCity){
        [userDataManager.user setValue:selectedCity forKey:@"city"];
        [userDataManager saveUserToPlist:userDataManager.user];
        //[userDataManager saveCityToPlist:selectedCity];
        [userDataManager updateUser:userDataManager.user];
    }
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"MixtableRedrawCityNotification"
     object:self
     ];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)initCities{
    MixtableCityDataManager* cityManager = [MixtableCityDataManager sharedInstance];
    if(cityManager){
        NSArray *cititesArray = [cityManager getAllCities];
        int index = 0;
        for(MixtableCity *city in cititesArray){
            if(city){
                NSString* cityName = city.name;
                if(cityName && [cityName length]){
                    [cities addObject:cityName];
                    if([cityName isEqualToString:selectedCity])
                        selectedCityIndex = index;
                }
            }
            index++;
        }
    }
}
#pragma pickerview

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    //One column
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //set number of rows
    return cities.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //set item per row
    return [cities objectAtIndex:row];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    selectedCity = [cities objectAtIndex:row];
}

@end
