//
//  DemoVC.h
//  RCloudMessage
//
//  Created by 韩渌 on 15/9/8.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface PlanViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain)UINavigationBar        *navBar;            //导航栏

@property (nonatomic,retain)UITableView            *projectTableView;  //项目列表

@property (nonatomic,retain)NSMutableArray         *projectNameList;   //项目名字

@property (nonatomic,retain)NSMutableArray         *projectStyleList;  //项目风格

@property (nonatomic,retain)NSMutableArray         *projectPreviewImage;

@property (nonatomic,retain)NSMutableArray         *projectPanoURL;

@end

