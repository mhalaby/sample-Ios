//
//  MixtablePreferencesCell.m
//  Mixtable
//
//  Created by Muhammad on 02/12/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import "MixtableBasicPreferencesCell.h"

@implementation MixtableBasicPreferencesCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGSize size = self.contentView.frame.size;
        _cellTitle = [[UILabel alloc] initWithFrame:CGRectMake(25, 8.0, size.width/4, size.height - 16.0)];
        _cellInput = [[UITextField alloc] initWithFrame:CGRectMake(size.width/2 -45, 9.0, size.width/2 + 16.0, size.height - 16.0)];
        [_cellTitle setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:14]];
        [_cellTitle setTextColor:[UIColor colorWithRed:61/255.0f green:167/255.0f blue:196/255.0f alpha:1.0f]];
        [_cellTitle setTextAlignment:NSTextAlignmentRight];
        [_cellInput setBorderStyle:UITextBorderStyleNone];
        [_cellInput setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
        [self.contentView addSubview:_cellInput];
        [self.contentView addSubview:_cellTitle];
        [_cellInput addTarget:self
                      action:@selector(textFieldDidChange:)
            forControlEvents:UIControlEventEditingChanged];

    }
    return self;
}

-(void)textFieldDidChange:(UITextField *)textField
{
    [super.userDataManager.user setValue:[textField text] forKey:self._tag];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
