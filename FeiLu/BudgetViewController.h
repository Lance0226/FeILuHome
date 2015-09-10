//
//  ViewController.h
//  RCloudMessage
//
//  Created by lance on 9/9/15.
//  Copyright (c) 2015 RongCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVSegmentedControl.h"

@interface BudgetViewController : UIViewController<UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,retain) NSString     *panoURL;                          //全景图URL

@property (nonatomic,retain) UIWebView *panoView;                         //全景图画布

@property (nonatomic,retain) NSNumber  *xmlIndex;                         //传递的预算列表的xml的序数

@property (retain,nonatomic) UITableView* budgetTblView;                  //预算表tableview

@property (retain,nonatomic) UIActivityIndicatorView *indicator; //指示器

@property (retain,nonatomic) SVSegmentedControl *sectionControl;



@end
