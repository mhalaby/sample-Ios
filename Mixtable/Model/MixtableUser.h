//
//  MixtableUser.h
//  Mixtable
//
//  Created by Muhammad on 24/11/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface MixtableUser : NSObject
@property(strong, nonatomic) NSString* userName;
@property(strong, nonatomic) NSString* first_name;
@property(strong, nonatomic) NSString* last_name;
@property(strong, nonatomic) NSString* profileImageID;
@property(strong, nonatomic) NSString* email;
@property(strong, nonatomic) NSString* city;
@property(strong, nonatomic) NSString* gender;
@property(strong, nonatomic) NSString* phone;
@property(strong, nonatomic) NSString* religion;
@property(strong, nonatomic) NSString* state;
@property(strong, nonatomic) NSString* height;
@property(strong, nonatomic) NSString* target_age;
@property(strong, nonatomic) NSString* target_venue;
@property(strong, nonatomic) NSString* target_expectation;
@property(strong, nonatomic) NSString* target_conversation;
@property(strong, nonatomic) NSString* newsletter_accepted;
@property(strong, nonatomic) NSString* preferred_languages;
@property(strong, nonatomic) NSString* preferred_genders;
@property(strong, nonatomic) NSString* occupations;
@property(strong, nonatomic) NSString* education;
@property(strong, nonatomic) NSString* status;
@property( nonatomic) bool firstTime;
@property( nonatomic) bool firstLogin;
@property(nonatomic, strong) NSMutableArray* bookings;
@end