//
//  MixtableDataManager.h
//  Mixtable
//
//  Created by Muhammad on 02/12/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MixtableAPIClient.h"
#import "MixtableAPIClientDelegate.h"
#import "MixtableUserDataManagerDelegate.h"

@interface MixtableDataManager : NSObject<MixtableAPIClientDelegate>
@property (strong, nonatomic) MixtableAPIClient *apiClient;
@end
