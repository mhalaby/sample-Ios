//
//  MixtableSliderCell.m
//  Mixtable
//
//  Created by Muhammad on 03/12/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import "MixtableSliderCell.h"

@implementation MixtableSliderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGSize size = self.contentView.frame.size;
        _cellTitle = [[UILabel alloc] initWithFrame:CGRectMake(25.0, 1.0, size.width, size.height - 16.0)];
        
        [_cellTitle setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:14]];
        [_cellTitle setTextColor:[UIColor colorWithRed:61/255.0f green:167/255.0f blue:196/255.0f alpha:1.0f]];
        
        [_cellTitle setTextAlignment:NSTextAlignmentLeft];

        _slider =[[UISlider alloc]initWithFrame:CGRectMake(8, size.height/2 +8, size.width-20, size.height/2 +5)];
        [_slider setTintColor:[UIColor colorWithRed:244/255.0f green:134/255.0f blue:106/255.0f alpha:1.0f]];
        
        [_slider setValue:0.5];
        
        _maxTitle = [[UILabel alloc] initWithFrame:CGRectMake(size.width-130, size.height +8, 120, size.height - 16.0)];
        [_maxTitle setTextAlignment:NSTextAlignmentRight];

        [_maxTitle setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:12]];
        
        _minTitle = [[UILabel alloc] initWithFrame:CGRectMake(8, size.height +8, size.width, size.height - 16.0)];
        
        [_minTitle setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:12]];
        [self.contentView addSubview:_minTitle];
        [self.contentView addSubview:_maxTitle];
        [self.contentView addSubview:_slider];
        [self.contentView addSubview:_cellTitle];
        
        [_slider addTarget:self action:@selector(sliderMove:) forControlEvents:UIControlEventValueChanged];

    }
    return self;
}
-(void)sliderMove:(UISlider*) slider {
    [super.userDataManager.user setValue:[[NSNumber numberWithFloat:[slider value] *100] stringValue]
 forKey:self._tag];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if([super.userDataManager.user valueForKey:self._tag] != (id)[NSNull null]) {
         if (super.userDataManager.user.firstTime != YES) {
             [_slider setValue:[[super.userDataManager.user valueForKey:self._tag] floatValue]/100];
         }else {
             [_slider setValue:0.5];
             [super.userDataManager.user setValue:[[NSNumber numberWithFloat:[_slider value] *100] stringValue]
                                           forKey:self._tag];         }
    }
}

@end
