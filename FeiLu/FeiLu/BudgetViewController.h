//
//  PanoViewController.h
//  FeiLu
//
//  Created by lance on 8/26/15.
//  Copyright (c) 2015 lance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BudgetViewController : UIViewController<UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain) NSURL     *panoURL;                          //全景图URL

@property (nonatomic,retain) UIWebView *panoView;                         //全景图画布

@property (nonatomic,retain) NSNumber  *xmlIndex;                         //传递的预算列表的xml的序数

@property (strong,nonatomic) UITableView* budgetTblView;                  //预算表tableview

@property (strong,nonatomic) UIActivityIndicatorView *indicator; //指示器

@end
