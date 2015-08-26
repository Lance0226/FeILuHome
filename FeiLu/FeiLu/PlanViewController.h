//
//  SecondViewController.h
//  FeiLu
//
//  Created by lance on 8/13/15.
//  Copyright (c) 2015 lance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface PlanViewController : UIViewController

@property (nonatomic,retain)UINavigationBar        *navBar;            //导航栏

@property (nonatomic,retain)UITableView            *projectTableView;  //项目列表

@property (nonatomic,retain)NSMutableArray         *projectNameList;   //项目名字

@property (nonatomic,retain)NSMutableArray         *projectPreviewImage;

@property (nonatomic,retain)NSMutableArray         *projectPanoURL;

@end

