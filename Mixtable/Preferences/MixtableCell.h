//
//  MixtableCell.h
//  Mixtable
//
//  Created by Muhammad on 28/03/14.
//  Copyright (c) 2014 Mixtable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MixtableUserDataManager.h"

@interface MixtableCell : UITableViewCell
@property(nonatomic) MixtableUserDataManager* userDataManager;
@property (nonatomic, strong) IBOutlet NSString* _tag;
@property (nonatomic, strong) IBOutlet NSArray* _items;

@end
