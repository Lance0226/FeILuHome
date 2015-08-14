//
//  ESrollerView.h
//  FeiLu
//
//  Created by lance on 8/14/15.
//  Copyright (c) 2015 lance. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EScrollerViewDelegate <NSObject>
@optional
-(void)EScrollerViewDidClicked:(NSUInteger)index;
@end

@interface EScrollerView : UIView<UIScrollViewDelegate> {
    CGRect viewSize;
    UIScrollView *scrollView;
    NSArray *imageArray;
    NSArray *titleArray;
    UIPageControl *pageControl;
    id<EScrollerViewDelegate> delegate;
    int currentPageIndex;
    UILabel *noteTitle;
}
@property(nonatomic,retain)id<EScrollerViewDelegate> delegate;
-(id)initWithFrameRect:(CGRect)rect ImageArray:(NSArray *)imgArr TitleArray:(NSArray *)titArr;
@end

