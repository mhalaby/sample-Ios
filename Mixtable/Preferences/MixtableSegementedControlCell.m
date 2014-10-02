//
//  MixtableSegementedControlCell.m
//  Mixtable
//
//  Created by Muhammad on 03/12/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import "MixtableSegementedControlCell.h"
#import "MultiSelectSegmentedControl.h"

@implementation MixtableSegementedControlCell 
@synthesize userDataManager = _userDataManager;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGSize size = self.contentView.frame.size;
        _cellTitle = [[UILabel alloc] initWithFrame:CGRectMake(25.0, 1.0, size.width, size.height - 16.0)];
        [_cellTitle setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:14]];
        [_cellTitle setTextColor:[UIColor colorWithRed:61/255.0f green:167/255.0f blue:196/255.0f alpha:1.0f]];
        [_cellTitle setTextAlignment:NSTextAlignmentLeft];
        NSArray *itemArray = [NSArray arrayWithObjects: @"One", @"Two", nil];
        _segmentedControl =[[UISegmentedControl alloc]  initWithItems:itemArray];
        [_segmentedControl setFrame:CGRectMake(25, size.height/2 +5, size.width - 60, size.height/2 +12)];
        [_segmentedControl setTintColor:[UIColor colorWithRed:244/255.0f green:134/255.0f blue:106/255.0f alpha:1.0f]];
        
        [self.contentView addSubview:_segmentedControl];
        
        [self.contentView addSubview:_cellTitle];
        [_segmentedControl  addTarget:self
                               action:@selector(segmentedControlValueChanged:)
                     forControlEvents:UIControlEventValueChanged];


    }

    return self;
}

-(void)loadValues {
    NSInteger counter = 0;
    for (NSString* value in self._items) {
        [_segmentedControl setTitle:value forSegmentAtIndex:counter];
        counter++;
    }
    if(self._tag)
    if([super.userDataManager.user valueForKey:self._tag] != (id)[NSNull null])
    [_segmentedControl setSelectedSegmentIndex:[self._items indexOfObject:[super.userDataManager.user valueForKey:self._tag]]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    [self loadValues];
    // Configure the view for the selected state
}
-(void)segmentedControlValueChanged:(UISegmentedControl *)segmentedControl{
    [super.userDataManager.user setValue:[segmentedControl titleForSegmentAtIndex:[segmentedControl selectedSegmentIndex]] forKey:self._tag];
}

@end
