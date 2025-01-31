//
//  ViewController.h
//  RCloudMessage
//
//  Created by lance on 9/9/15.
//  Copyright (c) 2015 RongCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVSegmentedControl.h"
#import "EScrollerView.h"

@interface PlanDetailViewController : UIViewController<UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,retain) NSString     *panoURL;                        //全景图URL

@property (nonatomic,retain) NSNumber  *xmlIndex;                         //传递的预算列表的xml的序数

@property (nonatomic,retain) UIButton *shareBtn;                          //导航栏分享按钮

@property (nonatomic,retain) UIWebView *panoView;                         //全景图画布

@property (retain,nonatomic) UITableView *budgetTblView;                  //预算表tableview

@property (retain,nonatomic) UIView    *perspView;                       //透视图画布



@property (retain,nonatomic) UIActivityIndicatorView *indicator;          //指示器

@property (retain,nonatomic) NSNumber   *curSectionIndex;                 //根据切换条记录当前页面

@property (retain,nonatomic) NSMutableDictionary *arrInfoImg;

@property (retain,nonatomic) NSMutableDictionary *arrPerspImg;


@property (retain,nonatomic) EScrollerView *scrollerView1;               //俯视图

@property (retain,nonatomic) EScrollerView *scrollerView2;               //预览图


@property (retain,nonatomic) SVSegmentedControl *sectionControl;



@end
