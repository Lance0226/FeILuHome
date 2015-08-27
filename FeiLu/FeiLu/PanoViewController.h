//
//  PanoViewController.h
//  FeiLu
//
//  Created by lance on 8/26/15.
//  Copyright (c) 2015 lance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PanoViewController : UIViewController<UITableViewDataSource,UITableViewDataSource,UIWebViewDelegate>

@property (nonatomic,retain) NSURL     *panoURL;
@property (nonatomic,retain) UIWebView *panoView;

@end
