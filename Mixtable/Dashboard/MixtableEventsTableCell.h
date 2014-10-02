//
//  MixtableEventsTableCell.h
//  Mixtable
//
//  Created by Wessam Abdrabo on 11/17/13.
//  Copyright (c) 2013 Mixtable. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MixtableEventsTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *eventWeekdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *eventTimeOfDayLabel;
@end
