//
//  TestViewController.m
//  UIScrollViewController
//
//  Created by Jakey on 15/1/31.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import "TestViewController.h"
#import "EmptyViewController.h"
@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor grayColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark * UIPanGestureRecognizer delegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    //    NSString *str = [NSString stringWithUTF8String:object_getClassName(gestureRecognizer)];
    
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:self];
        return fabs(translation.x) > fabs(translation.y);
    }
    return YES;
}
- (IBAction)emptyTouched:(id)sender {
    EmptyViewController *empty = [[EmptyViewController alloc]init];
    [self.navigationController pushViewController:empty animated:YES];
   
}
@end
