//
//  ViewController.m
//  HorizontalScrollerDemo
//
//  Created by Sola on 2/24/16.
//  Copyright © 2016 Sola. All rights reserved.
//

#import "ViewController.h"
#import "HorizontalScroller.h"

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController () <HorizontalScrollerDelegate>{
    NSMutableArray *imgNamesArr;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    imgNamesArr = [[NSMutableArray alloc] initWithObjects:@"img0.jpg", @"img1.jpg", @"img2.jpg", @"img3.jpg", nil];
    HorizontalScroller *scroller = [[HorizontalScroller alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT/3.0)];
    scroller.delegate = self;
    [scroller reload];
    [scroller shouldAutoShow:NO];
    [self.view addSubview:scroller];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark HorizontalScrollerDelegate Method
// 询问delegate在滚动区域有多少个图被显示
- (NSInteger)numberOfViewsForHorizontalScroller:(HorizontalScroller *)scroller{
    return imgNamesArr.count;
}

// 返回索引是index的视图
- (UIView *)horizontalScroller:(HorizontalScroller *)scroller viewAtIndex:(int)index{
    UILabel *strLab = [[UILabel alloc] initWithFrame:CGRectMake(20, scroller.frame.size.height - 30, scroller.frame.size.width, 30)];
    [strLab setNumberOfLines:0];
    strLab.textColor = [UIColor whiteColor];
    strLab.textAlignment = NSTextAlignmentLeft;
    [strLab setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    [strLab setText:[imgNamesArr objectAtIndex:index]];
    UIImageView *recImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[imgNamesArr objectAtIndex:index]]];
    [recImgView setFrame:CGRectMake(0, 0, scroller.frame.size.width, scroller.frame.size.height)];
    [recImgView addSubview:strLab];
    return recImgView;
}

// 当索引是index的视图被点击后通知delegate
- (void)horizontalScroller:(HorizontalScroller *)scroller clickedViewAtIndex:(int)index{
    NSLog(@"%i", index);
}

// 设置默认视图的index，如果没有被delegate实现则返回的是0
- (NSInteger)initialViewIndexForHorizontalScroller:(HorizontalScroller *)scroller{
    return 0;
}

@end
