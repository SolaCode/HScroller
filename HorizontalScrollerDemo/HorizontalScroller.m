//
//  HorizontalScroller.m
//  HorizontalScrollerDemo
//
//  Created by Sola on 2/24/16.
//  Copyright © 2016 Sola. All rights reserved.
//

#import "HorizontalScroller.h"

@interface HorizontalScroller () <UIScrollViewDelegate>{
    UIScrollView *scroller;
    UIPageControl* pageCtrl;
    NSTimer *_autoScrollTimer;
    NSInteger _currentPage;
    NSInteger _numOfViewsForScroller;
    BOOL isAutoShow;
}
@end

@implementation HorizontalScroller

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:scroller];
        scroller.delegate = self;
        scroller.pagingEnabled = YES;
        scroller.alwaysBounceHorizontal = YES;
        scroller.directionalLockEnabled = YES;
        scroller.showsHorizontalScrollIndicator = NO;
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollerTapped:)];
        [scroller addGestureRecognizer:tapRecognizer];
        //创建UIPageControl，位置在屏幕最下方。
        pageCtrl = [[UIPageControl alloc] initWithFrame:CGRectMake(frame.size.width/5*4, frame.size.height-20, frame.size.width/7, 20)];
        //将UIPageControl添加到主界面上。
        [self addSubview:pageCtrl];
    }
    return self;
}

- (void)scrollerTapped:(UITapGestureRecognizer *)gesture{
    CGPoint location= [gesture locationInView:gesture.view];
    for (int index = 0; index < [self.delegate numberOfViewsForHorizontalScroller:self]+2; index++) {
        UIView *view = scroller.subviews[index];
        if (CGRectContainsPoint(view.frame, location)) {
            if (index == _numOfViewsForScroller + 1) index = 1;
            index--;
            [self.delegate horizontalScroller:self clickedViewAtIndex:index];
            break;
        }
    }
}

- (void)reload{
    if (!self.delegate) return;
    
    //删除所有的子视图
    [scroller.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    
    //添加scroller子视图
    CGFloat xValue;
    UIView *view = [self.delegate horizontalScroller:self viewAtIndex:((int)[self.delegate numberOfViewsForHorizontalScroller:self]-1)];
    view.frame = CGRectMake(xValue, 0, view.frame.size.width, view.frame.size.height);
    [scroller addSubview:view];
    xValue = xValue + view.frame.size.width;
    for (int i = 0; i < [self.delegate numberOfViewsForHorizontalScroller:self]; i++) {
        UIView *view = [self.delegate horizontalScroller:self viewAtIndex:i];
        view.frame = CGRectMake(xValue, 0, view.frame.size.width, view.frame.size.height);
        [scroller addSubview:view];
        xValue = xValue + view.frame.size.width;
    }
    view = [self.delegate horizontalScroller:self viewAtIndex:0];
    view.frame = CGRectMake(xValue, 0, view.frame.size.width, view.frame.size.height);
    [scroller addSubview:view];
    xValue = xValue + view.frame.size.width;
    
    //scrollview可以滚动的区域
    [scroller setContentSize:CGSizeMake(xValue, self.frame.size.height)];
    if ([self.delegate respondsToSelector:@selector(initialViewIndexForHorizontalScroller:)]) {
        NSInteger initialViewIndex = [self.delegate initialViewIndexForHorizontalScroller:self];
        _currentPage = initialViewIndex + 1;
        pageCtrl.currentPage = initialViewIndex;
    }else{
        _currentPage = 1;
        pageCtrl.currentPage = 0;
    }
    
    //scroller默认的ContentOffset
    [scroller setContentOffset:CGPointMake(_currentPage * scroller.frame.size.width, 0) animated:YES];
    _numOfViewsForScroller = (int)[self.delegate numberOfViewsForHorizontalScroller:self];
    pageCtrl.numberOfPages = _numOfViewsForScroller;//总的图片页数
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (isAutoShow) {
        [_autoScrollTimer invalidate];
        _autoScrollTimer = nil;
    }
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.frame;
    _currentPage = offset.x / bounds.size.width;
    if (_currentPage == 0) {
        _currentPage = _numOfViewsForScroller;
        [scroller scrollRectToVisible:CGRectMake(scroller.frame.size.width * _numOfViewsForScroller, 0, scroller.frame.size.width, scroller.frame.size.height) animated:NO];
        [pageCtrl setCurrentPage:_numOfViewsForScroller-1];
    }else if (_currentPage == _numOfViewsForScroller+1){
        _currentPage = 1;
        [scroller scrollRectToVisible:CGRectMake(scroller.frame.size.width, 0, scroller.frame.size.width, scroller.frame.size.height) animated:NO];
        [pageCtrl setCurrentPage:0];
    }else{
        [pageCtrl setCurrentPage:_currentPage - 1];
    }
    [pageCtrl setCurrentPage:_currentPage - 1];
    if (isAutoShow) {
        _autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(autoShowNextImage) userInfo:nil repeats:YES];
    }
}

#pragma mark 自动滚动
-(void)shouldAutoShow:(BOOL)shouldStart
{
    isAutoShow = shouldStart;
    if (shouldStart)  //开启自动翻页
    {
        if (!_autoScrollTimer) {
            _autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(autoShowNextImage) userInfo:nil repeats:YES];
        }
    }
    else   //关闭自动翻页
    {
        if (_autoScrollTimer.isValid) {
            [_autoScrollTimer invalidate];
            _autoScrollTimer = nil;
        }
    }
}

#pragma mark 展示下一页
-(void)autoShowNextImage
{
    if (_currentPage == 1) {
        [scroller setContentOffset:CGPointMake(scroller.frame.size.width, 0) animated:NO];
    }
    _currentPage ++;
    if (_currentPage == _numOfViewsForScroller+1){
        [scroller scrollRectToVisible:CGRectMake(scroller.frame.size.width * _currentPage, 0, scroller.frame.size.width, scroller.frame.size.height) animated:YES];
        _currentPage = 1;
        [pageCtrl setCurrentPage:0];
    }else{
        [scroller scrollRectToVisible:CGRectMake(scroller.frame.size.width * _currentPage, 0, scroller.frame.size.width, scroller.frame.size.height) animated:YES];
        [pageCtrl setCurrentPage:_currentPage - 1];
    }
}

- (void)removeFromSuperview
{
    [super removeFromSuperview];
    if ([_autoScrollTimer isValid])
    {
        [_autoScrollTimer invalidate];
        _autoScrollTimer = nil;
    }
}

-(void)dealloc
{
    NSLog(@"_autoScrollTimer销毁");
    
}

@end
