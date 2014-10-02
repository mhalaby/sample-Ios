//
//  MixtablePickerControlCell.m
//  Mixtable
//
//  Created by Muhammad on 17/12/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import "MixtableCustomPickerControlCell.h"
#import "V8HorizontalPickerView.h"
@implementation MixtableCustomPickerControlCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGSize size = self.contentView.frame.size;
        _cellTitle = [[UILabel alloc] initWithFrame:CGRectMake(25, 8.0, size.width/4, size.height - 16.0)];
     
        [_cellTitle setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:14]];
        [_cellTitle setTextColor:[UIColor colorWithRed:61/255.0f green:167/255.0f blue:196/255.0f alpha:1.0f]];
        [_cellTitle setTextAlignment:NSTextAlignmentLeft];
        _picker = [[V8HorizontalPickerView alloc] initWithFrame:CGRectMake(size.width/4 ,8.0, size.width/2 + 40,30)];
        self.picker.backgroundColor   = [UIColor whiteColor];
        self.picker.selectedTextColor = [UIColor orangeColor];
        self.picker.textColor   = [UIColor grayColor];
       	self.picker.selectionPoint = CGPointMake(70, 0);
        self.picker.delegate = self;
        self.picker.dataSource = self;
        UIImageView *indicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"indicator"]];
        self.picker.selectionIndicatorView = indicator;
        self.picker.elementFont = [UIFont fontWithName:@"HelveticaNeue-Medium" size:14];
        [self.contentView addSubview:_picker];
        [self.contentView addSubview:_cellTitle];

        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if ([super.userDataManager.user valueForKey:self._tag] != (id)[NSNull null] ) {
        [self.picker scrollToElement:[self._items indexOfObject:[super.userDataManager.user valueForKey:self._tag]] animated:YES];
    }
}


#pragma mark - HorizontalPickerView DataSource Methods
- (NSInteger)numberOfElementsInHorizontalPickerView:(V8HorizontalPickerView *)picker {
	return [self._items count];
}

#pragma mark - HorizontalPickerView Delegate Methods
- (NSString *)horizontalPickerView:(V8HorizontalPickerView *)picker titleForElementAtIndex:(NSInteger)index {
	return [self._items objectAtIndex:index];
}

- (NSInteger) horizontalPickerView:(V8HorizontalPickerView *)picker widthForElementAtIndex:(NSInteger)index {
    [self._items objectAtIndex:index];
	return 40.0f; // 20px padding on each side
}

- (void)horizontalPickerView:(V8HorizontalPickerView *)picker didSelectElementAtIndex:(NSInteger)index {
        if(index < [self._items count])
        [super.userDataManager.user setValue:[self._items objectAtIndex:index] forKey:self._tag];

}


@end
