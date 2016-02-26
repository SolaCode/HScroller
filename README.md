# HScroller

####使用方法
```
HorizontalScroller *scroller = [[HorizontalScroller alloc] initWithFrame:yourFrame];
scroller.delegate = self;
[scroller reload];
[scroller shouldAutoShow:YES];
[self.view addSubview:scroller];
```
##### Delegate Method
```
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
```

####演示
![Demo Introduce](intro.gif)


####联系作者
[Sola](mailto:541504156@qq.com)

欢迎PR 和 提 issue


