//
//  MixtableConfigManager.m
//  Mixtable
//
//  Created by Wessam Abdrabo on 4/26/14.
//  Copyright (c) 2014 Mixtable. All rights reserved.
//

#import "MixtableConfigManager.h"
#define MIXTABLE_CONFIG_PLIST @"Mixtable-Config.plist"
@interface MixtableConfigManager(){
    NSArray *searchPaths;
    NSString *docStorePath;
    NSString *dataFilePath;
    NSMutableDictionary* _plistDict;
}
@end
@implementation MixtableConfigManager
+ (id)sharedInstance {
    static MixtableConfigManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        docStorePath = [searchPaths objectAtIndex:0];
        dataFilePath = [docStorePath stringByAppendingPathComponent:MIXTABLE_CONFIG_PLIST];
        if(![[NSFileManager defaultManager]fileExistsAtPath:dataFilePath]){
            [[NSFileManager defaultManager]copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"Mixtable-Config" ofType:@"plist"] toPath:dataFilePath error:nil];
        }
        _plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:dataFilePath];
    }
    return self;
}
-(NSString*) getTwitterPageURL{
    if(!_plistDict || ![_plistDict count])
        return @"";
    return [_plistDict objectForKey:@"MixtableTwitterPageURL"];
}
-(NSString*) getContactEmail{
    if(!_plistDict || ![_plistDict count])
        return @"";
    return [_plistDict objectForKey:@"MixtableContactEmail"];
}
-(NSString*) getContactNumber{
    if(!_plistDict || ![_plistDict count])
        return @"";
    return [_plistDict objectForKey:@"MixtableContactNumber"];
}
-(NSString*) getMixpicsPageURL{
    if(!_plistDict || ![_plistDict count])
        return @"";
    return [_plistDict objectForKey:@"MixtableMixpicsURL"];
}
-(NSString*) getFAQPageURL{
    if(!_plistDict || ![_plistDict count])
        return @"";
    return [_plistDict objectForKey:@"MixtableFAQURL"];
}
-(NSString*) getTnCsPageURL{
    if(!_plistDict || ![_plistDict count])
        return @"";
    return [_plistDict objectForKey:@"MixtableTnCsURL"];
}
-(NSString*) getPaymillActiveMode{
    if(!_plistDict || ![_plistDict count])
        return @"";
    return [_plistDict objectForKey:@"MixtablePaymillActiveMode"];
}
-(NSString*) getPaymillPublicKey{
    if(!_plistDict || ![_plistDict count])
        return @"";
    return [_plistDict objectForKey:@"MixtablePaymillPublicKey"];
}
-(NSString*) getFBPageID{
    if(!_plistDict || ![_plistDict count])
        return @"";
    return [_plistDict objectForKey:@"MixtableFBPageID"];
}
-(NSString*)getPaymentAmount{
    if(!_plistDict || ![_plistDict count])
        return @"";
    return [_plistDict objectForKey:@"MixtablePaymentAmount"];
}
-(NSString*)getAPIUrl{
    if(!_plistDict || ![_plistDict count])
        return @"";
    return [_plistDict objectForKey:@"MixtableAPIUrl"];
}
@end
