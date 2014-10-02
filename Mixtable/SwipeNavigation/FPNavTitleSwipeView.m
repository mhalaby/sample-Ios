//
//  FPNavTitleSwipeView.m
//  PaigeeWorld
//
//  Created by Farhan Patel on 12-11-14.
//
//

#import "FPNavTitleSwipeView.h"
#import <QuartzCore/QuartzCore.h>

@interface FPNavTitleSwipeView ()

@property(strong)UIScrollView* scrollView;
@property(strong)NSArray* items;

-(void)scrollForward;
-(void)scrollBackward;

@end

@implementation FPNavTitleSwipeView
@synthesize scrollView,items,delegate,currentPage,currentPageColor,pageColor;

- (id)initWithFrame:(CGRect)frame titleItems:(NSArray*)titleItems
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setOpaque:NO];
        
        currentPage = 0;
        
        items = titleItems;
        
        //the default colors of the current page and selected page
        pageColor = [UIColor lightGrayColor];
        currentPageColor = [UIColor grayColor];
        
        scrollView = [[UIScrollView alloc] initWithFrame:frame];
        [scrollView setContentSize:CGSizeMake([items count]*CGRectGetWidth(frame),40)];
        [scrollView setBackgroundColor:[UIColor clearColor]];
        [scrollView setDelegate:self];
        [scrollView setPagingEnabled:YES];
        [scrollView setShowsHorizontalScrollIndicator:NO];
        [scrollView setBounces:NO];
        [scrollView setScrollEnabled:NO];
        
        
        for (int i = 0; i < [items count]; i++) {
            
            //customize the label. Set the text alignment, color and other title stuff.
            UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(i*CGRectGetWidth(scrollView.frame), 0, 120, 40)];
            [button setBackgroundColor:[UIColor clearColor]];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:20]];
            [button.titleLabel setAdjustsFontSizeToFitWidth:YES];
            [button.titleLabel setMinimumScaleFactor:3];
            [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
            [button setTitle:[titleItems objectAtIndex:i] forState:UIControlStateNormal];
            
            /*removed to enable only swiping not clicking */
            //[button addTarget:self action:@selector(scrollForward) forControlEvents:UIControlEventTouchUpInside];
            
            
            //gesutres for the swiping left/right
            UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(scrollForward)];
            swipe.direction = UISwipeGestureRecognizerDirectionLeft;
            [button addGestureRecognizer:swipe];
            
            UISwipeGestureRecognizer *leftswipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(scrollBackward)];
            leftswipe.direction = UISwipeGestureRecognizerDirectionRight;
            [button addGestureRecognizer:leftswipe];
            
            [scrollView addSubview:button];
        }
        
        /* Customization for Mixtable: slider image views*/
        self.rectView = [[UIImageView alloc] initWithFrame:CGRectMake(23, 33, 76, 4 )];
        self.sliderView = [[UIImageView alloc] initWithFrame:CGRectMake(49, 33, 25, 4)];
        
        UIImage *rectImage = [UIImage imageNamed: @"swipe-rect.png"];
        UIImage *sliderImage = [UIImage imageNamed: @"swipe-slider.png"];
        
        [self.rectView setImage: rectImage];
        [self.sliderView setImage:sliderImage];
        
        [self addSubview:self.rectView];
        [self addSubview:self.sliderView];
        [self addSubview:scrollView];
        [self setNeedsDisplay];
    }
    
    [self scrollForward]; //hack!! to start at mid element
    
    return self;
}

-(void)scrollForward {
    if(currentPage == 2) //stop circular motion
        return;
    int nextPage =  (currentPage + 1) % [self.items count];

    if ([delegate respondsToSelector:@selector(titleViewChange:)]) {
        [delegate titleViewChange:nextPage];
    }
    
    CGFloat pageWidth = scrollView.bounds.size.width;
    currentPage = nextPage;
    [scrollView setContentOffset:CGPointMake(nextPage*pageWidth, 0) animated:YES];
    [self setNeedsDisplay];
}

-(void)scrollBackward {
    if(currentPage == 0) //stop circular motion
        return;
    int nextPage =  (currentPage - 1);
    
    if (nextPage == -1){
        nextPage = [self.items count]-1;
    }
    if ([delegate respondsToSelector:@selector(titleViewChange:)]) {
        [delegate titleViewChange:nextPage];
    }
    
    CGFloat pageWidth = scrollView.bounds.size.width;
    currentPage = nextPage;
    [scrollView setContentOffset:CGPointMake(nextPage*pageWidth, 0) animated:YES];
    [self setNeedsDisplay];
}

/* custom added to swipe to notifications from notifications button */
-(void) scrollToNotifications
{
    if(currentPage == 0) /*already on notificaitons, do nothing*/
        return;
    
    int nextPage = 0; /* next page is always notificaitons*/
    
    if ([delegate respondsToSelector:@selector(titleViewChange:)]) {
        [delegate titleViewChange:nextPage];
    }
    
    CGFloat pageWidth = scrollView.bounds.size.width;
    currentPage = nextPage;
    [scrollView setContentOffset:CGPointMake(nextPage*pageWidth, 0) animated:YES];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    /* Cusotmization for Mixtable: check the current page and change the x value for slider.
     Only works with 3 pages. Values are hardcoded. */
    if(currentPage == 0)
        [self.sliderView setFrame:CGRectMake(23, 33, 25, 4)];
    else if(currentPage == 1)
        [self.sliderView setFrame:CGRectMake(49, 33, 25, 4)];
    else if(currentPage == 2)
        [self.sliderView setFrame:CGRectMake(74, 33, 25, 4)];
    [self.sliderView setNeedsDisplay];
}


@end
