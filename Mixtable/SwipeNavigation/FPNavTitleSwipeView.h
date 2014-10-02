//
//  FPNavTitleSwipeView.h
//  PaigeeWorld
//
//  Created by Farhan Patel on 12-11-14.
//
//

#import <UIKit/UIKit.h>

@protocol FPNavTitleSwipeDelegate;


@interface FPNavTitleSwipeView : UIView<UIScrollViewDelegate>

@property(weak)NSObject<FPNavTitleSwipeDelegate>* delegate;
@property(assign)int currentPage;
@property(nonatomic,strong)UIColor* currentPageColor;
@property(strong)UIColor* pageColor;
@property(nonatomic, strong) UIImageView *rectView;
@property(nonatomic, strong) UIImageView *sliderView;

- (id)initWithFrame:(CGRect)frame titleItems:(NSArray*)titleItems;
-(void) scrollToNotifications;
-(void)scrollForward;
-(void)scrollBackward;
@end

@protocol FPNavTitleSwipeDelegate
- (void)titleViewChange:(int)page;
@end
