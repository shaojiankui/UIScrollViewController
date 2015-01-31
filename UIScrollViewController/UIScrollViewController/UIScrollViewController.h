//
//  UIScrollViewController.h
//  UIScrollViewController
//
//  Created by Jakey on 15/1/31.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollViewController : UIViewController<UIScrollViewDelegate>

@property (nonatomic, strong) IBOutlet UIView * contentView;
@property (nonatomic, strong) IBOutlet UIScrollView*scrollView;

@end
