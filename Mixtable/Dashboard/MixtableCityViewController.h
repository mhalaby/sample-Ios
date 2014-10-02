//
//  MixtableCityViewController.h
//  Mixtable
//
//  Created by Wessam Abdrabo on 4/22/14.
//  Copyright (c) 2014 Mixtable. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MixtableCityViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *cityPicker;
-(id) initWithSelectedCity:(NSString*)city;
@end
