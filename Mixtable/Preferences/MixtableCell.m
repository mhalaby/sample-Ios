//
//  MixtableCell.m
//  Mixtable
//
//  Created by Muhammad on 28/03/14.
//  Copyright (c) 2014 Mixtable. All rights reserved.
//

#import "MixtableCell.h"

@implementation MixtableCell
@synthesize userDataManager = _userDataManager;
@synthesize _tag = __tag;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _userDataManager = [MixtableUserDataManager sharedManager];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
