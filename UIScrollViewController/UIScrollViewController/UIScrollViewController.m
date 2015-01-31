//
//  UIScrollViewController.m
//  UIScrollViewController
//
//  Created by Jakey on 15/1/31.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import "UIScrollViewController.h"

@interface UIScrollViewController ()

@end

@implementation UIScrollViewController


- (UIScrollView *)createScrollView
{
    //_scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    //20px
    _scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.clipsToBounds = NO;
    _scrollView.canCancelContentTouches = NO;
    _scrollView.delaysContentTouches = YES;
    return _scrollView;
}
- (void)loadView
{
    // Try to load self.view
    // Let super load it
    NSString * nibName = self.nibName;
    if (self.storyboard && // Has a Storyboard
        nibName && // Has an assigned nibName
        ![[NSBundle mainBundle]pathForResource:nibName ofType:@"nib"])
    {
        [super loadView];
        return;
    }
    // From a Nib
    if (!nibName || nibName.length == 0)
    {
        nibName = NSStringFromClass([self class]);
    }
    if([[NSBundle mainBundle]pathForResource:nibName ofType:@"nib"])
    {
        NSLog(@"Loading nib '%@' for class '%@'", nibName, NSStringFromClass([self class]));
        // Check if set with owner
        NSArray * loadedObjects = [[NSBundle mainBundle] loadNibNamed:nibName
                                                                owner:self
                                                              options:nil];
        // Else set it to the first loaded object
        if (!self.isViewLoaded &&
            [loadedObjects[0] isKindOfClass:[UIView class]])
        {
            self.view = loadedObjects[0];
        }
        return;
    }
    // Else if still not set create an empty one
    NSLog(@"~~~ Nib for class %@ didn't set a view. An empty scrollView will be created",
          NSStringFromClass([self class]));
    self.view = [self createScrollView];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // Make sure scrollView is set
    if (!_scrollView)
    {
        // Set it to self.view?
        if ([self.view isKindOfClass:[UIScrollView class]])
        {
            _scrollView = (UIScrollView *)self.view;
        }
        // Create a new one and set it as the new self.view
        else
        {
            // Save the current self.view?
            if (!_contentView)
            {
                _contentView = self.view;
            }
            self.view = [self createScrollView];
        }
    }
    // Set scrollView delegate
    _scrollView.delegate = self;
    
    if (!_contentView)
    {
        // If not set we expect it to be a scrollView's subview
        if ([_scrollView subviews].count == 0)
        {
            @throw [NSException exceptionWithName:@"ScrollViewControllerException"
                                           reason:[NSString stringWithFormat:@"%@ A contentView couldn't be found", self]
                                         userInfo:nil];
        }
        _contentView = (_scrollView.subviews)[0];
    }
    // Add contentView to scrollView if necessary
    if (_contentView.superview != _scrollView)
    {
        CGRect bounds = _scrollView.bounds;
        CGRect frame = _contentView.frame;
        _contentView.frame = CGRectMake(bounds.origin.x,
                                        bounds.origin.y,
                                        bounds.size.width,
                                        frame.size.height);
        [_scrollView addSubview:_contentView];
    }
    
//    // Make sure the controller's view autoresizes as needed
//    self.view.autoresizingMask = (self.view.autoresizingMask |
//                                  UIViewAutoresizingFlexibleHeight |
//                                  UIViewAutoresizingFlexibleWidth);
    NSLog(@"~~~ %@ %p viewDidLoad", NSStringFromClass([self class]), self);
}
- (void)setScrollViewContentSize:(CGSize)size
{
    if (!CGSizeEqualToSize(size, _scrollView.contentSize))
    {
        NSLog(@">> %@ %@",
              NSStringFromCGSize(_scrollView.contentSize), NSStringFromCGPoint(_scrollView.contentOffset));
        // CGPoint offset = _scrollView.contentOffset;
        _scrollView.contentSize = size;
        // _scrollView.contentOffset = offset;
        NSLog(@"<< %@ %@",
              NSStringFromCGSize(_scrollView.contentSize), NSStringFromCGPoint(_scrollView.contentOffset));
    }
    
}
- (IBAction)sizeToFitContentView:(id)sender
{
    CGSize sizeThatFits = [_contentView sizeThatFits:CGSizeMake(_scrollView.bounds.size.width,
                                                                CGFLOAT_MAX)];
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _contentView.frame = CGRectMake(_contentView.frame.origin.x,
                                                         _contentView.frame.origin.y,
                                                         sizeThatFits.width,
                                                         sizeThatFits.height);
                         [self setScrollViewContentSize:sizeThatFits];
                         NSLog(@"*** sizeToFitContentView = %@", NSStringFromCGSize(_scrollView.contentSize));
                     }
                     completion:^(BOOL finished) {
                     }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // Update scrollView content size
    [self setScrollViewContentSize:_contentView.bounds.size];
    if (CGSizeEqualToSize(_scrollView.contentSize, CGSizeZero))
    {
        [self sizeToFitContentView:self];
    }

    NSLog(@"--- %@ %@", self.view, _scrollView);
}
- (void)scrollViewToVisible:(UIView *)view
                  topMargin:(CGFloat)topMargin
               bottomMargin:(CGFloat)bottomMargin
{
    CGRect rect = [_scrollView convertRect:view.bounds
                                  fromView:view];
    rect.origin.x -= topMargin;
    rect.size.height += topMargin + bottomMargin;
    [_scrollView scrollRectToVisible:rect
                            animated:YES];
}

@end
