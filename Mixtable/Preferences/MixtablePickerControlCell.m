//
//  MixtablePickerControlCell.m
//  Mixtable
//
//  Created by Muhammad on 17/12/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import "MixtablePickerControlCell.h"

@implementation MixtablePickerControlCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGSize size = self.contentView.frame.size;
        _cellTitle = [[UILabel alloc] initWithFrame:CGRectMake(25, 8.0, size.width, size.height - 16.0)];
        [_cellTitle setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:14]];
        [_cellTitle setTextColor:[UIColor colorWithRed:61/255.0f green:167/255.0f blue:196/255.0f alpha:1.0f]];
        [_cellTitle setTextAlignment:NSTextAlignmentLeft];
        _picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0 ,-50, size.width/2 + 100,1)];
        self.picker.delegate = self;
        self.picker.dataSource = self;
        [self.contentView addSubview:_cellTitle];
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake( size.width/2 - 135,35,size.width + 100,70)];
        [self.scrollView addSubview:_picker];
        [self.contentView addSubview:self.scrollView];

    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if ([super.userDataManager.user valueForKey:self._tag] != (id)[NSNull null] &&
        [self._items indexOfObject:[super.userDataManager.user valueForKey:self._tag]] < [self._items count]) {
        [self.picker selectRow:[self._items indexOfObject:[super.userDataManager.user valueForKey:self._tag]] inComponent:0 animated:YES];

    }
     // Configure the view for the selected state
}

#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return self._items.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return self._items[row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row
          forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *retval = (id)view;
    if (!retval) {
        retval= [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [_picker rowSizeForComponent:component].width, [_picker rowSizeForComponent:component].height)] ;
    }
    retval.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    [retval setTextAlignment:NSTextAlignmentCenter];
    retval.text = self._items[row];
    return retval;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [super.userDataManager.user setValue:[self._items objectAtIndex:row] forKey:self._tag];
}
@end
