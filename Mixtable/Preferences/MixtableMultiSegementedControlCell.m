//
//  MixtableMulitSegementedControlCell.m
//  Mixtable
//
//  Created by Muhammad El-Halaby on 12/17/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import "MixtableMultiSegementedControlCell.h"
#import "MultiSelectSegmentedControl.h"
@interface MixtableMultiSegementedControlCell () <MultiSelectSegmentedControlDelegate>
@end
@implementation MixtableMultiSegementedControlCell

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
        _multiSegmentedControl =[[MultiSelectSegmentedControl alloc]  initWithItems:itemArray];
        [_multiSegmentedControl setFrame:CGRectMake(25, size.height/2 +5, size.width - 60, size.height/2 +12)];
        [_multiSegmentedControl setTintColor:[UIColor colorWithRed:244/255.0f green:134/255.0f blue:106/255.0f alpha:1.0f]];
        _multiSegmentedControl.delegate = self;

        [self.contentView addSubview:_multiSegmentedControl];
        
        [self.contentView addSubview:_cellTitle];
        
    }
    return self;
}
-(void)loadValues {
    NSInteger counter = 0;
    for (NSString* value in self._items) {
        if(counter > 1)
        {
            [_multiSegmentedControl insertSegmentWithTitle:value atIndex:counter animated:NO];
        }else{
            [_multiSegmentedControl setTitle:value forSegmentAtIndex:counter];
        }
        counter++;
    }
    if(self._tag)
        if([super.userDataManager.user valueForKey:self._tag])
        {
            if([super.userDataManager.user valueForKey:self._tag] != (id)[NSNull null] && [[super.userDataManager.user valueForKey:self._tag] length] !=0 ) {
                NSArray *elements = [[super.userDataManager.user valueForKey:self._tag] componentsSeparatedByString:@","];
                NSMutableIndexSet* matchesIndexSet = [[NSMutableIndexSet alloc] init];

                for (NSString* e in elements) {
                    [matchesIndexSet addIndex:[self._items indexOfObject:e] ];
                }
                
                [_multiSegmentedControl setSelectedSegmentIndexes:matchesIndexSet];
            }
     
        }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    [self loadValues];
}
-(void)multiSelect:(MultiSelectSegmentedControl *)multiSelectSegmendedControl didChangeValue:(BOOL)value atIndex:(NSUInteger)index{
   
    NSString * result = [[self._items objectsAtIndexes:[multiSelectSegmendedControl selectedSegmentIndexes]] componentsJoinedByString:@","];
    [super.userDataManager.user setValue:result forKey:self._tag];

}
@end
