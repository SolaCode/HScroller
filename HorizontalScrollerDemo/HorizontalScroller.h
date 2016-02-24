//
//  HorizontalScroller.h
//  HorizontalScrollerDemo
//
//  Created by Sola on 2/24/16.
//  Copyright © 2016 Sola. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HorizontalScrollerDelegate;

@interface HorizontalScroller : UIView

@property (weak) id<HorizontalScrollerDelegate> delegate;
- (void)reload;
- (void)shouldAutoShow:(BOOL)shouldStart;

@end

@protocol HorizontalScrollerDelegate <NSObject>

@required
// 询问delegate在滚动区域有多少个图被显示
- (NSInteger)numberOfViewsForHorizontalScroller:(HorizontalScroller *)scroller;

// 返回索引是index的视图
- (UIView *)horizontalScroller:(HorizontalScroller *)scroller viewAtIndex:(int)index;

// 当索引是index的视图被点击后通知delegate
- (void)horizontalScroller:(HorizontalScroller *)scroller clickedViewAtIndex:(int)index;

@optional
// 设置默认视图的index，如果没有被delegate实现则返回的是0
- (NSInteger)initialViewIndexForHorizontalScroller:(HorizontalScroller *)scroller;

@end